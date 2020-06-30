# frozen_string_literal: true

require 'socialfred/publications'

module Socialfred
  class Api
    attr_reader :api_key, :api_url

    API_URL = 'https://api.socialfred.com/'

    def initialize(api_key, api_url: API_URL)
      @api_key = api_key
      @api_url = api_url
    end

    def publications
      @publications ||= Publications.new(api_key, api_url: api_url)
    end
  end
end
