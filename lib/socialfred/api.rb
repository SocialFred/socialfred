# frozen_string_literal: true

require 'faraday'

module Socialfred
  class Api
    attr_reader :api_key

    def initialize(api_key)
      @api_key = api_key
    end

    def social_posts
      @social_posts ||= SocialPosts.new(api_key)
    end
  end
end
