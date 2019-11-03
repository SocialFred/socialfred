# frozen_string_literal: true

require 'faraday'
require 'socialfred/social_posts'
require 'socialfred/requester'

module Socialfred
  class Api
    attr_reader :api_key, :api_url

    API_URL = 'https://app.socialfred.com/api/'

    def initialize(api_key, api_url: API_URL)
      @api_key = api_key
      @api_url = api_url
    end

    def social_posts
      @social_posts ||= SocialPosts.new(api_key, api_url: api_url)
    end
  end
end
