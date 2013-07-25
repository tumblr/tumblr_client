require 'faraday'
require 'faraday_middleware'

module Tumblr
  module Connection

    def connection(options={})
      
      default_options = {
        :headers => {
          :accept => 'application/json',
          :user_agent => "tumblr_client (ruby) - #{Tumblr::VERSION}"
        },
        :url => "http://#{api_host}/"
      }

      Faraday.new("http://#{api_host}/", default_options.merge(options)) do |builder|
        data = { :api_host => api_host }.merge(credentials)

        unless credentials.empty?
          builder.use Faraday::Request::OAuth, data
        end
        builder.use Faraday::Request::Multipart
        builder.use Faraday::Request::UrlEncoded
        builder.use FaradayMiddleware::ParseJson, :content_type => 'application/json'
        builder.use Faraday::Adapter::NetHttp
      end
    end

  end
end
