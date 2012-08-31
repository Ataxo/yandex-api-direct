# encoding: utf-8
require 'net/http'
require 'json'

module YandexApiDirect
  class CampaignStats < Hashr
    
    include YandexObject
    extend YandexObject

    #get stats for campaign
    # input args:
    # {
    #   campaign_ids: [Integer]
    #   start_date: Date
    #   end_date: Date
    # }
    def self.find params = {}
      call_method("get_summary_stat", camelize_keys(params))[:data].collect do |stats_data|
        new stats_data
      end
    end

  end
end