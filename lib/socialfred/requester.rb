# frozen_string_literal: true

module Socialfred
  class Requester
    attr_reader :api_key, :api_url

    def initialize(api_key, api_url)
      @api_key = api_key
      @api_url = api_url
    end

    def get(endpoint, parameters = nil)
      conn.get(endpoint, parameters) do |req|
        req.headers[:content_type] = 'application/json'
      end
    end

    def post(endpoint, parameters = nil)
      conn.post(endpoint) do |req|
        req.headers[:content_type] = 'application/json'
        req.body = JSON.generate(parameters)
      end
    end

    def put(endpoint, parameters = nil)
      conn.put(endpoint) do |req|
        req.headers[:content_type] = 'application/json'
        req.body = JSON.generate(parameters)
      end
    end

    def delete(endpoint)
      conn.delete(endpoint) do |req|
        req.headers[:content_type] = 'application/json'
      end
    end

    private

    def conn
      @conn ||= Faraday.new(url: api_url) do |faraday|
        faraday.adapter Faraday.default_adapter
        faraday.headers['Api-Key'] = api_key
      end
    end
  end
end
