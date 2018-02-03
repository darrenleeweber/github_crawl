# Serializers
require 'json'
require 'yaml'

# Github data
require 'octokit'
require 'github_crawl/repo'
require 'github_crawl/user'
require 'github_crawl/version'

# Local persistence
require 'sequel'
require 'sqlite3'
require 'github_crawl/sawyer_serializer'
require 'github_crawl/sql_db'
require 'github_crawl/sql_base'
require 'github_crawl/sql_repos'
require 'github_crawl/sql_users'

# HTTP Cache
# see https://github.com/plataformatec/faraday-http-cache
require 'active_support/cache'
require 'faraday/http_cache'

require 'fileutils'
data_path = 'github_crawl_data'
cache_path = File.join(data_path, 'http_cache')
FileUtils.mkdir_p cache_path
store = ActiveSupport::Cache.lookup_store(:file_store, cache_path)

stack = Faraday::RackBuilder.new do |builder|
  builder.use Faraday::HttpCache, serializer: Marshal, store: store, shared_cache: false
  builder.use Octokit::Response::RaiseError
  builder.adapter Faraday.default_adapter
end
Octokit.middleware = stack
