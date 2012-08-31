# encoding: utf-8
require 'test_helper'

class TestCampaign < Test::Unit::TestCase

  context "Yandex Campaign" do
    setup do
      set_sandbox_access

      # webmock get campaign list
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
            with(:body => "{\"method\":\"GetCampaignsList\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{}}",
                 :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_get_campaigns_list.json"))

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
      end
    end

  end
end
