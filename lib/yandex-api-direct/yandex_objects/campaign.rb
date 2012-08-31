# encoding: utf-8
require 'net/http'
require 'json'

module YandexApiDirect
  class Campaign < Hashr
    
    include YandexObject
    extend YandexObject

    #perform find call
    def self.find params = {}
      call_method("get_campaigns_list", params)[:data].collect do |campaign_args|
        new campaign_args
      end
    end

  end
end