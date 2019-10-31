# frozen_string_literal: true

require 'time'

module Socialfred
  class SocialPosts
    attr_reader :api_key, :api_url

    ENDPOINT = 'social_posts'

    def initialize(api_key, api_url:)
      @api_key = api_key
      @api_url = api_url
    end

    def all(page: 1, per_page: 10)
      response = conn.get(ENDPOINT, page: page, per_page: per_page)

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def find(social_post_id)
      response = conn.get(ENDPOINT + "/#{social_post_id}")

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def create(publish_at: nil, text:, images: nil, options: nil)
      publish_at = Time.parse(publish_at.to_s).iso8601 if publish_at
      parameters = { social_post: { published_at: publish_at, text: text, images: images, options: options }.compact }
      response = conn.post(ENDPOINT, parameters)

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def update(social_post_id, publish_at: nil, text:, images: nil, options: nil)
      publish_at = Time.parse(publish_at.to_s).iso8601 if publish_at
      parameters = { social_post: { published_at: publish_at, text: text, images: images, options: options }.compact }
      response = conn.put(ENDPOINT + "/#{social_post_id}", parameters)

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def destroy(social_post_id)
      response = conn.delete(ENDPOINT + "/#{social_post_id}")

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    private

    def conn
      @conn ||= Faraday.new(url: api_url) do |faraday|
        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Api-Key'] = api_key
      end
    end
  end
end
