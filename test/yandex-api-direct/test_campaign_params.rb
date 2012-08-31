# encoding: utf-8
require 'test_helper'

#require "webmock/test_unit"

class TestCampaignParams < Test::Unit::TestCase

  context "Yandex Campaign Params" do
    setup do
      set_sandbox_access

      # webmock campaign params
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
        with( :body => "{\"method\":\"GetCampaignParams\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\",\"param\":{\"CampaignID\":123451}}",
              :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_campaign_params.json"))

    end

    context "find" do
      setup do 
        @campaign_param = YandexApiDirect::CampaignParams.find campaign_id: 123451
      end

      should "have right attributes" do
        assert_equal @campaign_param.name, "Campaign #1"
      end

    end

  end
end
