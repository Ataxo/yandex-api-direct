# encoding: utf-8
require 'test_helper'

#require "webmock/test_unit"

class TestClient < Test::Unit::TestCase

  context "Yandex Client" do
    setup do
      set_sandbox_access
    end

    context "initialization" do
      should "have methods defined by params" do
        client = YandexApiDirect::Client.new( foo: "bar")
        assert_equal client.foo, "bar"
      end
    end

    context "find" do
      setup do 
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
          to_return(:status => 200, :body => load_fixture("yandex_get_client_list.json"))
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
        stub_request(:post, "https://api-sandbox.direct.yandex.ru/json-api/v4/").
          to_return(:status => 200, :body => load_fixture("yandex_get_campaigns_list.json"))
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

  end
end
