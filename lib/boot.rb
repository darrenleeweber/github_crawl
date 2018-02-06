# Setup data path
FileUtils.mkdir_p 'github_crawl_data'

# Serializers
require 'json'
require 'yaml'

# Github data
require 'octokit'
require 'github_crawl/cache'
require 'github_crawl/github_repo'
require 'github_crawl/github_user'
require 'github_crawl/version'

Octokit.auto_paginate = true

github_user = ENV['GITHUB_USER']
github_pass = ENV['GITHUB_PASS']
unless (github_user.nil? || github_user.empty?) && (github_pass.nil? || github_pass.empty?)
  Octokit.configure do |c|
    c.login = github_user
    c.password = github_pass
  end
  # # TODO: try to use an auth-token
  # auth = Octokit.create_authorization(:scopes => ["user"], :note => "GithubCrawl")
  # Octokit.bearer_token = auth[:token]
end
