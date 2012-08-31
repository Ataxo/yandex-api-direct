# encoding: utf-8
require 'test_helper'


class TestYandexObject < Test::Unit::TestCase

  context "Yandex object" do
    setup do
      set_sandbox_access
    end

    context "initialization" do
      setup do
        @args_camelized = {
          :'Foo'=> "bar",
          :'BarFoo' => "foo bar",
          :'Deep' => {
            :'DarkSide' => "bar"
          }
        }

        @object = TestingYandexObject.new @args_camelized
      end

      should "have added methods for params" do
        assert_equal @object.foo, "bar"
        assert_equal @object.bar_foo, "foo bar"
      end

      context "change keys" do
        setup do 
          @args_underscored = {
            foo: "bar",
            bar_foo: "foo bar",
            deep: {
              dark_side: "bar"
            }
          }
        end

        should "take care about more ID characters Underscore" do
          assert_equal @object.underscore_keys("CampaignID" => "foo"), {campaign_id: "foo" }
          assert_equal @object.underscore_keys("FIO" => "foo"), {fio: "foo" }
        end

        should "take care about more ID characters Camelize" do
          assert_equal @object.camelize_keys(campaign_id: "foo"), {:"CampaignID" => "foo"}
          assert_equal @object.camelize_keys(fio: "foo"), {:"FIO" => "foo"}
        end

        should "underscore keys" do
          assert_equal @object.underscore_keys(@args_camelized), @args_underscored
        end
    
        should "camelize keys" do
          assert_equal @object.camelize_keys(@args_underscored), @args_camelized
        end

        should "camelize keys only for Hash, Array return without update" do
          assert_equal @object.camelize_keys(["test"]), ["test"]
        end

      end
    end

    context "valid call" do
      setup do
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").to_return(:status => 200, :body => load_fixture("yandex_object_valid_responce.json"))
        @responce = TestingYandexObject.new.call_method "get_client_info", [YandexApiDirect.config[:login]]
      end
      
      should "return not nil" do
        assert_not_nil @responce
      end
      
      should "return hash" do
        assert @responce.is_a?(Hash)
      end

    end

    context "authorization error" do
      setup do
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").to_return(:status => 200, :body => "{\"error_detail\":\"\",\"error_str\":\"Authorization error\",\"error_code\":53}")
      end
      
      should "raise exception" do
        assert_raises YandexApiDirect::YandexAuthorizationError do
          TestingYandexObject.new.call_method "get_client_info", [YandexApiDirect.config[:login]]
        end
      end      
    end

    context "unknown method error" do
      setup do
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").to_return(:status => 200, :body => "{\"error_detail\":\"\",\"error_str\":\"Authorization error\",\"error_code\":55}")
      end
      
      should "raise exception" do
        assert_raises YandexApiDirect::YandexMethodError do
          TestingYandexObject.new.call_method "unkwnown method", [YandexApiDirect.config[:login]]
        end
      end      
    end

    context "generic error" do
      setup do
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").to_return(:status => 200, :body => "{\"error_detail\":\"\",\"error_str\":\"Authorization error\",\"error_code\":123}")
      end
      
      should "raise exception" do
        assert_raises YandexApiDirect::YandexError do
          TestingYandexObject.new.call_method "get_client_info", [YandexApiDirect.config[:login]]
        end
      end      
    end

    context "bad connection" do
      setup do
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").to_return(:status => 502, :body => "502 Bad Gateway")
      end
      
      should "raise exception" do
        assert_raises YandexApiDirect::YandexConnectionError do
          TestingYandexObject.new.call_method "get_client_info", [YandexApiDirect.config[:login]]
        end
      end      
    end

  end
end
