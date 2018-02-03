require 'boot'

module GithubCrawl
  DB = SqlDb.new

  # Check the rate limit
  # @return [void]
  def self.check_rate_limit
    response = Octokit.last_response
    return if response.nil?
    rate_limit = response.headers['x-ratelimit-limit'].to_i # hits per hour
    rate_remaining = response.headers['x-ratelimit-remaining'].to_i
    rate_reset = response.headers['x-ratelimit-reset'].to_i
    return if rate_remaining > 100
    puts "WARNING: rate limit (#{rate_limit}) remainder: #{rate_remaining}"
    puts "WARNING: rate limit (#{rate_limit}) resets at #{Time.at(rate_reset)}"
  end
end
