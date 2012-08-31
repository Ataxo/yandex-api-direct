# encoding: utf-8
require 'test_helper'

#require "webmock/test_unit"

class TestCampaignStats < Test::Unit::TestCase

  context "Yandex Campaign Stats" do
    setup do
      set_sandbox_access

      # webmock campaign stats
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with( :body => "{\"method\":\"GetSummaryStat\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"CampaignIDS\":[123451],\"StartDate\":\"2008-11-13\",\"EndDate\":\"2008-11-15\"}}",
              :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_campaign_stats.json"))

    end

    context "find" do
      setup do 
        @campaign_stats = YandexApiDirect::CampaignStats.find campaign_ids: [123451], start_date: Date.new(2008,11,13), end_date: Date.new(2008,11,15)
      end

      should "have right attributes" do
        assert_equal @campaign_stats.first.campaign_id, 123451
      end

      should "be for 3 days" do
        assert_equal @campaign_stats.size, 3
      end
    end

  end
end
