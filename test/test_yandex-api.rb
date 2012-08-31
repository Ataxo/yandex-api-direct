# encoding: utf-8
require 'test_helper'

class TestYandexApiDirect < Test::Unit::TestCase

  context "Setup config values" do

    should "have defaults" do
      assert_not_nil YandexApiDirect.config
    end

    should "be set" do
      conf = YandexApiDirect.config.merge({ access_token: "Test"})
      YandexApiDirect.config = conf
      assert_equal YandexApiDirect.config, conf
    end
    
  end

  context "Yandex url" do
    should "be set to sandbox for tests" do
      assert_equal YandexApiDirect.url, "https://api-sandbox.direct.yandex.ru/json-api/v4/"
    end

    should "be set to sandbox by param" do
      YandexApiDirect.url "sandbox"
      assert_equal YandexApiDirect.url, "https://api-sandbox.direct.yandex.ru/json-api/v4/"
    end

    should "be set to production by setting it to production" do
      YandexApiDirect.url "production"
      assert_equal YandexApiDirect.url, "https://soap.direct.yandex.ru/json-api/v4/"
    end

  end
end
