# encoding: utf-8
require 'test_helper'

#require "webmock/test_unit"

class TestGeneric < Test::Unit::TestCase

  context "Yandex Generic" do
    setup do
      set_sandbox_access

      # webmock get client list
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
            with(:body => "{\"method\":\"GetClientsList\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\"}",
                 :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
        to_return(:status => 200, :body => load_fixture("yandex_get_client_list.json"))

      # webmock get client info
      stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
            with(:body => "{\"method\":\"GetClientInfo\",\"locale\":\"uk\",\"login\":\"\",\"application_id\":\"\",\"token\":\"\"}",
                 :headers => {'Accept'=>'*/*', 'Content-Type'=>'application/json', 'User-Agent'=>'Ruby'}).
            to_return(:status => 200, :body => load_fixture("yandex_get_client_info.json"))
    end

    context "get only one item" do
      setup do 
        @generic = YandexApiDirect::Generic.get "get_client_info"
      end

      should "have right attributes" do
        assert_equal @generic.login, "test"
      end

    end

    context "get more one items" do
      setup do 
        @generics = YandexApiDirect::Generic.get "get_clients_list"
      end

      should "be array" do
        assert @generics.is_a?(Array)
      end
    end

  end
end
