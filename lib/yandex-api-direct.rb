# encoding: utf-8

require 'active_support/inflector'
require 'active_support/inflector/inflections'
require 'active_support/core_ext/hash/keys'
require 'hashr'

module YandexApiDirect

  # Return current environment
  # Uses RACK_ENV and RAILS_ENV - if not set any default is used "development"
  def self.env
    ENV['RACK_ENV'] || ENV['RAILS_ENV'] || "development"
  end

  # Get URL for all requests to Yandex api
  # * without parameter - Choose url by ENV
  # * with parameter 
  # * * "test" - choose sandbox
  # * * other - choose production
  def self.url environment = nil
    environment = env unless environment
    environment == "test" ? 
      "https://api-sandbox.direct.yandex.ru/json-api/v4/" : #sandbox url
      "https://soap.direct.yandex.ru/json-api/v4/" #production url
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