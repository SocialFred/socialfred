require 'time'

module Socialfred
  class SocialPosts
    attr_reader :api_key

    # API_URL = 'https://socialfred.com/api/'
    API_URL = 'http://localhost:3000/api/'

    ENDPOINT = 'social_posts'

    def initialize(api_key)
      @api_key = api_key
    end

    def index(page: 1, per_page: 10)
      response = conn.get(ENDPOINT, page: page, per_page: per_page) do |req|
        req.headers['Content-Type'] = 'application/json'
      end

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def find(social_post_id)
      response = conn.get(ENDPOINT + "/#{social_post_id}") do |req|
        req.headers['Content-Type'] = 'application/json'
      end

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def create(publish_at: Time.now, text:, images: [])
      publish_at = Time.parse(publish_at.to_s).iso8601
      response = conn.post(ENDPOINT, {social_post: {published_at: publish_at, text: text, images: images}})

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def update

    end

    def destroy(social_post_id)
      response = conn.delete(ENDPOINT + "/#{social_post_id}")

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    private

    def conn
      @conn ||= Faraday.new(url: API_URL) do |faraday|

        faraday.request :multipart
        faraday.request :url_encoded
        faraday.adapter Faraday.default_adapter
        faraday.headers['Api-Key'] = api_key
      end
    end
  end
end
