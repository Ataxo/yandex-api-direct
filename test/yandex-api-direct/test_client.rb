# encoding: utf-8
require 'test_helper'

class TestClient < Test::Unit::TestCase

  context "Yandex Client" do
    setup do
      set_sandbox_access

      # webmock get client list
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetClientsList\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{}}").
        to_return(:status => 200, :body => load_fixture("yandex_get_client_list.json"))

      # webmock get campaign list
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetCampaignsList\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":[\"test\"]}",
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_get_campaigns_list.json"))

      # webmock campaign params
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetCampaignsParams\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":[\"yand-10\"]}").
        to_return(:status => 200, :body => load_fixture("yandex_campaign_params.json"))

      # webmock campaign stats
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetSummaryStat\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"StartDate\":\"2008-11-13\",\"EndDate\":\"2008-11-15\",\"CampaignIDS\":[123451]}}",
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_campaign_stats.json"))

      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetSummaryStat\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"StartDate\":\"2008-11-13\",\"EndDate\":\"2008-11-15\",\"CampaignIDS\":[123452]}}",
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "{\"data\":[]}")

      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetSummaryStat\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"StartDate\":\"2008-11-13\",\"EndDate\":\"2008-11-15\",\"CampaignIDS\":[123453]}}",
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => "{\"data\":[]}")
    end

    context "initialization" do
      should "have methods defined by params" do
        client = YandexApiDirect::Client.new( foo: "bar")
        assert_equal client.foo, "bar"
      end
    end

    context "find" do
      setup do 
        @clients = YandexApiDirect::Client.find
      end

      should "be array" do
        assert @clients.is_a?(Array)
      end

      should "be array of Clients" do
        assert @clients.first.is_a?(YandexApiDirect::Client)
      end

      should "have right count of clients" do
        assert_equal @clients.size, 2
      end

      context "client" do
        setup do 
          @client = @clients.first
        end

        should "have right attributes" do
          assert_equal @client.login, "test", "Same login"
        end

        should "have underscored method names" do
          assert_equal @client.status_arch, "no"
        end
      end
    end

    context "campaigns find" do
      setup do 
        @client = YandexApiDirect::Client.find.first
      end

      should "be array" do
        assert @client.campaigns.is_a?(Array)
      end

      should "be array of campaigns" do
        assert @client.campaigns.first.is_a?(YandexApiDirect::Campaign)
      end

      should "be array of campaigns with valid informations" do
        assert_same_elements @client.campaigns.collect{|c| c.name}, ["Campaign #1","Campaign #2","Campaign #3"]
      end
    end

    context "campaigns stats" do
      setup do
        @client = YandexApiDirect::Client.find.first
      end

      should "return campaigns and inside of them stats" do
        campaigns = @client.campaigns_stats start_date: Date.new(2008,11,13), end_date: Date.new(2008,11,15)
        assert_equal campaigns.size, 3, "Should have 3 campaigns"
        assert_equal campaigns.first.stats.size, 3, "First campaign should have 3 date statistics"
        assert_equal campaigns.last.stats.size, 0, "Last campaign has no stats for this dates"
      end
    end
  end
end
