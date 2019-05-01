module Tumblr
  module Config

    VALID_OPTIONS_KEYS = [
      :consumer_key,
      :consumer_secret,
      :oauth_token,
      :oauth_token_secret,
      :client,
      :api_scheme
    ]

    VALID_OPTIONS_KEYS.each do |key|
      define_method "#{key}=" do |value|
        Thread.current["tumblr_client_#{key}"] = value
      end

      define_method key do
        Thread.current["tumblr_client_#{key}"]
      end
    end

    def configure
      yield self
      self
    end

    def options
      options = {}
      VALID_OPTIONS_KEYS.each{ |pname| options[pname] = send(pname) }
      options
    end

    def credentials
      {
        :consumer_key => consumer_key,
        :consumer_secret => consumer_secret,
        :token => oauth_token,
        :token_secret => oauth_token_secret
      }
    end

  end
end
