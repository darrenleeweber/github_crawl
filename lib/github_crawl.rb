require 'boot'

module GithubCrawl
  DB = SqlDb.new

  # Get the rate limit
  # @return [Hash]
  def self.rate_limit
    Octokit.rate_limit.to_h
  end

  # Check the rate limit
  # @return [void]
  def self.check_rate_limit
    rate = rate_limit
    return if rate[:remaining] > 50
    puts "RATE LIMIT WARNING:\t#{rate.inspect}"
  end
end
