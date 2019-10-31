# frozen_string_literal: true

require 'bundler/setup'
require 'vcr'
require 'socialfred'

VCR.configure do |config|
  config.cassette_library_dir = 'spec/support/vcr_cassettes'
  config.hook_into :faraday
end

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
