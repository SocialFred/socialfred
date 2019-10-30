# frozen_string_literal: true

RSpec.describe Socialfred::Api do
  let(:api_key) { 'example_api_key' }
  let(:default_api_url) { 'https://socialfred.com/api/' }

  describe '#initialize' do
    context 'when initialized without api_url' do
      subject(:api) { described_class.new(api_key) }

      it { expect(api.api_url).to eq(default_api_url) }
      it { expect(api.api_key).to eq(api_key) }
    end

    context 'when initialized with api_url' do
      subject(:api) { described_class.new(api_key, api_url: api_url) }

      let(:api_url) { 'http://localhost' }

      it { expect(api.api_url).to eq(api_url) }
      it { expect(api.api_key).to eq(api_key) }
    end
  end

  describe '#social_posts' do
    subject(:api) { described_class.new(api_key) }

    it { expect(api.social_posts).to be_an_instance_of(Socialfred::SocialPosts) }

    context 'when called multiple times' do
      let!(:social_posts) { class_double('Socialfred::SocialPosts').as_stubbed_const }
      let(:social_posts_instance) { instance_double('Socialfred::SocialPosts') }

      before do
        allow(social_posts).to receive(:new).and_return(social_posts_instance)
        2.times { api.social_posts }
      end

      it 'is initialized only once' do
        expect(social_posts).to have_received(:new).with(api_key, api_url: default_api_url).once
      end
    end
  end
end
