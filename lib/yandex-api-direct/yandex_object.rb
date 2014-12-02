# encoding: utf-8
require 'net/http'
require 'json'
require 'active_support'

module YandexApiDirect

  # Problem with connection
  class YandexConnectionError < Exception; end
  # Problem with request params
  class YandexMethodError < Exception; end
  # generic error
  class YandexError < Exception; end
  # Problem with authorization
  class YandexAuthorizationError < Exception; end
  
  # Globalize all same functions into one module
  # This will enable easier implementation
  # of Yandex objects
  module YandexObject
    extend ActiveSupport::Concern

    #include methods into class
    included do
      include YandexObjectInstance
      include YandexObjectCallMethod
      extend YandexObjectCallMethod
      extend YandexObjectClass
    end

    # Class methods for Yandex objects
    module YandexObjectClass

    end

    # Instance methods for Yandex objects
    module YandexObjectInstance
      
      # Change Camelized keys of hash to underscored keys
      def underscore_keys(hash)
        return nil unless hash
        hash.inject({}){|result, (key, value)|
          new_key = key.to_s.underscore.to_sym
          new_value = case value
                      when Hash then underscore_keys(value)
                      else value
                      end
          result[new_key] = new_value
          result
        }
      end

      #fix input arguments
      def initialize args = {}
        super underscore_keys(args)
      end
    end

    # Call method to Yandex API
    module YandexObjectCallMethod
      #Call method perform call to yandex api
      # * method name (string|symbol) - method name defined by yandex api
      # * param — single-string array with user's login name
      def call_method method_name, param = nil
        payload = {
          method: method_name.camelize,
          param: [YandexApiDirect.config[:login]],
          locale: YandexApiDirect.config[:locale],
          token: YandexApiDirect.config[:access_token]
        }

        # get url
        url = URI.parse(YandexApiDirect.url)

        # set new post request with JSON content type
        request = Net::HTTP::Post.new(url.path, initheader = {'Content-Type' =>'application/json'})

        # set payload to post body
        request.body = payload.to_json

        # create new connection to yandex
        http = Net::HTTP.new(url.host, url.port)

        # set use SSL 
        http.use_ssl = true
        http.verify_mode = OpenSSL::SSL::VERIFY_NONE

        # send request 
        response = http.request(request)

        # no problem with connection
        if response.code.to_i == 200
          #parse respose JSON body into hash
          resp = JSON.parse(response.body).symbolize_keys

          # if there is no error_code
          unless resp.has_key?(:error_code)
            return resp
          else # error code
            case resp[:error_code]
            when 53 then raise YandexAuthorizationError, "Got error from Yandex API, error code: #{resp[:error_code]} | #{resp[:error_str]} (#{resp[:error_detail]})"
            when 55 then raise YandexMethodError, "Got error from Yandex API, error code: #{resp[:error_code]} | #{resp[:error_str]} (#{resp[:error_detail]})"
            else raise YandexError, "Got error from Yandex API, error code: #{resp[:error_code]} | #{resp[:error_str]} (#{resp[:error_detail]})"
            end
          end
        else
          # Request responce is not valid (errors: 404, 500, etc.)
          raise YandexConnectionError, "Problem with connection to Yandex API, status code: #{response.code} \n content body: #{response.body}"
        end
      end

      # Change Camelized keys of hash to camelized keys
      def camelize_keys(hash)
        return nil unless hash
        return hash if hash.is_a?(Array)
        hash.inject({}){|result, (key, value)|
          new_key = key.to_s.camelize.gsub(/(Ids|Id|Fio)/) { |r| r.upcase }.to_sym
          new_value = case value
                      when Hash then camelize_keys(value)
                      else value
                      end
          result[new_key] = new_value
          result
        }
      end
    end

  end
end