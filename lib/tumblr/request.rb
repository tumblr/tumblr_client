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

    # Performs put request
    def put(path, params={})
      if Array === params[:tags]
        params[:tags] = params[:tags].join(',')
      end
      response = connection.put do |req|
        req.url path
        req.body = params unless params.empty?
      end
      respond(response)
    end

    # Performs delete request
    def delete(path, params={})
      response = connection.delete do |req|
        req.url path
        req.body = params unless params.empty?
      end
      respond(response)
    end

    def respond(response)
      if [201, 200].include?(response.status)
        response.body['response']
      else
        # surface the meta alongside response
        res = response.body['meta'] || {}
        res.merge! response.body['response'] if response.body['response'].is_a?(Hash)
        res
      end
    end

  end
end
