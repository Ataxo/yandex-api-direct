# encoding: utf-8
require 'test_helper'

class TestCampaign < Test::Unit::TestCase

  context "Yandex Campaign" do
    setup do
      set_sandbox_access

      # webmock get campaign list
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with( :body => "{\"method\":\"GetCampaignsList\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{}}",
              :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_get_campaigns_list.json"))

      # webmock campaign params
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with( :body => "{\"method\":\"GetCampaignParams\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"CampaignIDS\":[123451]}}",
              :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_campaign_params.json"))

      # webmock campaign stats
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with(:body => "{\"method\":\"GetSummaryStat\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"StartDate\":\"2008-11-13\",\"EndDate\":\"2008-11-15\",\"CampaignIDS\":[123451]}}",
             :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_campaign_stats.json"))

    end

    context "find" do
      setup do 
        @campaigns = YandexApiDirect::Campaign.find
      end

      should "be array" do
        assert @campaigns.is_a?(Array)
      end

      should "be array of Campaigns" do
        assert @campaigns.first.is_a?(YandexApiDirect::Campaign)
      end

      should "have right count of clients" do
        assert_equal @campaigns.size, 3
      end

      context "campaign" do
        setup do 
          @campaign = @campaigns.first
        end

        should "have right attributes" do
          assert_equal @campaign.name, "Campaign #1"
        end

        should "have campaign params" do
          assert @campaign.campaign_params.is_a?(YandexApiDirect::CampaignParam)
        end

        should "have campaign stats" do
          assert_equal @campaign.campaign_stats(start_date: Date.new(2008,11,13), end_date: Date.new(2008,11,15)).size, 3
        end

      end
    end

  end
end
