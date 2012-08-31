# encoding: utf-8
require 'net/http'
require 'json'

module YandexApiDirect
  class Client < Hashr
    
    include YandexObject
    extend YandexObject

    #perform find call
    def self.find params = {}
      call_method("get_clients_list", params)[:data].collect do |client_args|
        new client_args
      end
    end

    def campaigns
      call_method("get_campaigns_list", [login])[:data].collect do |campaign_args|
        Campaign.new campaign_args
      end
    end

  end
end