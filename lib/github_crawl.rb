require 'boot'

module GithubCrawl

  DATA_PATH = 'github_crawl_data'.freeze

  DB = SqlDb.new

  @@last_rate = Octokit.rate_limit.to_h

  # Get the rate limit
  # @return [Hash]
  def self.rate_limit
    Octokit.rate_limit.to_h
  end

  # Check the rate limit
  # @return [void]
  def self.check_rate_limit
    rate = rate_limit
    same_rate = rate[:remaining] == @@last_rate[:remaining]
    @@last_rate = rate
    return if rate[:remaining] > 50 || same_rate
    puts "RATE LIMIT WARNING:\t#{rate.inspect}"
  end
end
