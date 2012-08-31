# encoding: utf-8

require 'active_support/inflector'
require 'active_support/inflector/inflections'
require 'active_support/core_ext/hash/keys'
require 'hashr'

module YandexApiDirect

  URLS = {
    production: "https://soap.direct.yandex.ru/json-api/v4/", #production url
    sandbox: "https://api-sandbox.direct.yandex.ru/json-api/v4/" #sandbox url
  }
  # Return current environment
  # Uses RACK_ENV and RAILS_ENV - if not set any default is used "development"
  def self.env
    ["test"].include?(ENV['RACK_ENV'] || ENV['RAILS_ENV'] || "development") ? :sandbox : :production
  end

  # Get URL for all requests to Yandex api
  # * without parameter - Choose url by ENV
  # * with parameter 
  # * * "test" - choose sandbox
  # * * other - choose production
  def self.url environment = nil
    if environment
      @url = URLS[environment.to_sym]
    elsif @url
      @url
    else
      @url = URLS[env]
    end
  end

  # default config for Yandex API
  # * locale (language of api response)
  # * * "uk" - Ukraine
  # * * "ru" - Russian
  # * * "en" - English
  def self.default_config
    { 
      locale: "uk",
      application_id: "",
      login: "",
      access_token: "",
    }
  end

  @config = default_config

  # Set config values
  def self.config= conf
    @config = default_config.merge!(conf)
  end

  # Get config for requset params build
  def self.config
    @config
  end
end

#require yandex objects
require 'yandex-api-direct/yandex_object'
require 'yandex-api-direct/yandex_objects/client'
require 'yandex-api-direct/yandex_objects/campaign'
require 'yandex-api-direct/yandex_objects/campaign_param'