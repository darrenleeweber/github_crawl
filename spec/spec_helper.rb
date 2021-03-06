require 'bundler/setup'
require 'github_crawl'
require 'pry'

require 'vcr'
require 'webmock'
require 'webmock/rspec'
WebMock.enable!

require 'simplecov'
SimpleCov.start

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = '.rspec_status'

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

VCR.configure do |config|
  config.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  config.hook_into :webmock
  # config.allow_http_connections_when_no_cassette = true
  config.default_cassette_options = {
    record: :new_episodes, # :once is default
  }
  config.configure_rspec_metadata!
end

# Enable SQL for specs
TEST_SQL_CONN = Models::Conn.new('github_test.sqlite')
Models.set_db(TEST_SQL_CONN.conn)
GithubCrawl.sql_enable
