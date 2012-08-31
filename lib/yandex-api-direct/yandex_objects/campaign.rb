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

    #get params for campaign
    # input args:
    # {
    #   start_date: Date
    #   end_date: Date
    # }
    def campaign_params
      CampaignParams.find campaign_ids: [campaign_id]
    end

    #get stats for campaign
    # input args:
    # {
    #   start_date: Date
    #   end_date: Date
    # }
    def campaign_stats args
      CampaignStats.find args.merge(campaign_ids: [campaign_id])
    end

  end
end