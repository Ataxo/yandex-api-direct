# encoding: utf-8
require 'net/http'
require 'json'

module YandexApiDirect
  class Generic < Hashr
    
    include YandexObject
    extend YandexObject

    # get custom method response
    def self.get method_name, args = nil
      data = call_method(method_name, camelize_keys(args))[:data]
      if data.is_a?(Array)
        data.collect do |generic_data|
          new generic_data
        end
      else
        new data
      end
    end
  end
end