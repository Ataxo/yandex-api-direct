# -*- encoding : utf-8 -*-
require 'simplecov'
SimpleCov.start do 
  add_filter "/test/"
  add_filter "/config/"
  add_filter "database"
  
  add_group 'Lib', 'lib/'
end

require 'colorize'
require 'rubygems'
require 'bundler'
begin
  Bundler.setup(:default, :development)
rescue Bundler::BundlerError => e
  $stderr.puts e.message
  $stderr.puts "Run `bundle install` to install missing gems"
  exit e.status_code
end

require 'test/unit'
require 'mocha'
require 'turn'
require 'shoulda-context'

$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))
$LOAD_PATH.unshift(File.dirname(__FILE__))
require 'yandex-api-direct'

# Set test to use YML config
require 'yaml'

ENV['RACK_ENV'] = "test"

class MissingConfigFile < Exception ; end

def set_sandbox_access
  test_config = 'config/yandex_access.yml'
  raise MissingConfigFile, "Missing config file\n For testing please take #{test_config}.example and edit it to #{test_config} with your valid informations.\n Tests uses sandbox, will not do anythig to your existing data.\n Without config tests can't be started".red unless File.exists?(test_config)
  YandexApiDirect.config = YAML.load_file(test_config).symbolize_keys
end
set_sandbox_access

def load_fixture name
  File.open(File.join(File.dirname(__FILE__), "fixtures", name), "r:UTF-8").read
end

# test models
require 'models'

require "webmock/test_unit"
