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

    # get campaigns by client
    def campaigns
      call_method("get_campaigns_list", [login])[:data].collect do |campaign_args|
        Campaign.new campaign_args
      end
    end

    # get campaign stats for client by campaigns
    # input args:
    # {
    #   start_date: Date
    #   end_date: Date
    # }
    def campaigns_stats args
      campaigns.collect do |campaign|
        campaign.stats = campaign.campaign_stats(args.merge(campaign_ids: [campaign.campaign_id])).select{|s| s.campaign_id == campaign.campaign_id}
        campaign
      end
    end
  end
end