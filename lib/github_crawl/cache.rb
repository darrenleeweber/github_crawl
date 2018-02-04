require 'octokit'
require 'active_support/cache'
require 'faraday/http_cache'
require 'fileutils'

module GithubCrawl
  # HTTP Cache
  # see https://github.com/plataformatec/faraday-http-cache
  module Cache
    def self.enable
      cache_path = File.join(GithubCrawl::DATA_PATH, 'http_cache')
      FileUtils.mkdir_p cache_path
      store = ActiveSupport::Cache.lookup_store(:file_store, cache_path)
      stack = Faraday::RackBuilder.new do |builder|
        builder.use Faraday::HttpCache,
                    serializer: Marshal, store: store, shared_cache: false
        builder.use Octokit::Response::RaiseError
        builder.adapter Faraday.default_adapter
      end
      Octokit.middleware = stack
    end
  end
end
