require 'boot'

module GithubCrawl
  DATA_PATH = 'github_crawl_data'.freeze

  # Retrieve all the pages for a link relation
  # @param [Sawyer::Relation] relation
  # @return [Array] data
  def self.link_data(relation)
    response = relation.get
    data = response.data
    while response.rels[:next]
      response = response.rels[:next].get
      data.concat response.data
    end
    data
  end

  # ---
  # Rate limits

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
    # same_rate = rate[:remaining] == @@last_rate[:remaining]
    # @@last_rate = rate
    return if rate[:remaining] > 50 #|| same_rate
    puts "RATE LIMIT WARNING:\t#{rate.inspect}"
  end

  # ---
  # SQL config

  @@sql_enabled = false

  # @return [GithubCrawl::SqlConn]
  def self.sql_conn
    @@sql_conn ||= SqlConn.new
  end

  # @return [void]
  def self.sql_disable
    @@sql_enabled = false
  end

  # @return [void]
  def self.sql_enable
    @@sql_enabled = true
  end

  # @return [Boolean]
  def self.sql_enabled?
    @@sql_enabled
  end
end
