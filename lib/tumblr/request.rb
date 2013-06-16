require 'json'

module Tumblr
  module Request

    # Perform a get request and return the raw response
    def get_response(path, params = {})
      connection.get do |req|
        req.url path
        req.params = params
      end
    end

    # get a redirect url
    def get_redirect_url(path, params = {})
      response = get_response path, params
      if response.status == 301
        response.headers['Location']
      else
        response.body['meta']
      end
    end

    # Performs a get request
    def get(path, params={})
      respond get_response(path, params)
    end

    # Performs post request
    def post(path, params={})
      if Array === params[:tags]
        params[:tags] = params[:tags].join(',')
      end
      response = connection.post do |req|
        req.url path
        req.body = params unless params.empty?
      end
      #Check for errors and encapsulate
      respond(response)
    end

    def respond(response)
      if [201, 200].include?(response.status)
        response.body['response']
      else
      # no doubt surfacing the error reason from the response body along with the generic code
      # is going to save some other developer some very aggravating time discovering e.g. there's a daily
      # photo post limit on Tumblr...
        response.body['meta'].merge(response.body['response'])
      end
    end

  end
end
