# encoding: utf-8
require 'net/http'
require 'json'

module YandexApiDirect
  class CampaignParam < Hashr
    
    include YandexObject
    extend YandexObject

    #perform find call
    def self.find params = {}
      new call_method("get_campaign_params", camelize_keys(params))[:data]
    end

  end
end