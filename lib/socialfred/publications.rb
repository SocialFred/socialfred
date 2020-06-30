# frozen_string_literal: true

require 'socialfred/requester'
require 'time'

module Socialfred
  class Publications
    attr_reader :api_key, :api_url

    ENDPOINT = 'publications'

    def initialize(api_key, api_url:)
      @api_key = api_key
      @api_url = api_url
    end

    def all(page: 1, per_page: 10)
      response = requester.get(ENDPOINT, page: page, per_page: per_page)

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def find(publication_id)
      response = requester.get(ENDPOINT + "/#{publication_id}")

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def create(publish_at: nil, text:, images: nil, options: nil)
      check_images(images) if images

      publish_at = Time.parse(publish_at.to_s).iso8601 if publish_at
      parameters = { publication: { published_at: publish_at, text: text, images: images, options: options }.compact }
      response = requester.post(ENDPOINT, parameters)

      raise Socialfred::Error, response.body unless response.status == 200

      JSON.parse(response.body)
    end

    def update(publication_id, publish_at: nil, text: nil, images: nil, options: nil)
      check_images(images) if images

      publish_at = Time.parse(publish_at.to_s).iso8601 if publish_at
      parameters = { publication: { published_at: publish_at, text: text, images: images, options: options }.compact }
      response = requester.put(ENDPOINT + "/#{publication_id}", parameters)

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    def destroy(publication_id)
      response = requester.delete(ENDPOINT + "/#{publication_id}")

      raise Socialfred::Error unless response.status == 200

      JSON.parse(response.body)
    end

    private

    def check_images(images)
      raise(Socialfred::Error, 'images must be array') unless images.is_a?(Array)
      return if images.all? { |image| image.key?(:data) && image.key?(:filename) && image.key?(:content_type) }

      raise(
        Socialfred::Error,
        'images must contain the following attributes: data (base64 encoded image), filename and content_type'
      )
    end

    def requester
      @requester ||= Requester.new(api_key, api_url)
    end
  end
end
