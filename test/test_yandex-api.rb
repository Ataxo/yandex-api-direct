require 'helper'

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

    should "be set to sandbox by ENV" do
      ENV['RACK_ENV'] = "test"
      assert_equal YandexApiDirect.url, "https://api-sandbox.direct.yandex.ru/json-api/v4/"
    end

    should "be set to sandbox by param" do
      assert_equal YandexApiDirect.url("test"), "https://api-sandbox.direct.yandex.ru/json-api/v4/"
    end

    should "be set to production by ENV" do
      ENV['RACK_ENV'] = "development"
      assert_equal YandexApiDirect.url, "https://soap.direct.yandex.ru/json-api/v4/"
      ENV['RACK_ENV'] = "stage"
      assert_equal YandexApiDirect.url, "https://soap.direct.yandex.ru/json-api/v4/"
      ENV['RACK_ENV'] = "production"
      assert_equal YandexApiDirect.url, "https://soap.direct.yandex.ru/json-api/v4/"
    end

    should "be set to production by param" do
      assert_equal YandexApiDirect.url("development"), "https://soap.direct.yandex.ru/json-api/v4/"
      assert_equal YandexApiDirect.url("stage"), "https://soap.direct.yandex.ru/json-api/v4/"
      assert_equal YandexApiDirect.url("production"), "https://soap.direct.yandex.ru/json-api/v4/"
    end


  end
end
