[![Build Status](https://travis-ci.org/darrenleeweber/github_crawl.svg?branch=master)](https://travis-ci.org/darrenleeweber/github_crawl) [![Maintainability](https://api.codeclimate.com/v1/badges/ad8c3c4765c864f5b619/maintainability)](https://codeclimate.com/github/darrenleeweber/github_crawl/maintainability) [![Test Coverage](https://api.codeclimate.com/v1/badges/ad8c3c4765c864f5b619/test_coverage)](https://codeclimate.com/github/darrenleeweber/github_crawl/test_coverage)

# GithubCrawl

This is a command-line script to crawl Github user profiles.

Given the full name of a target github repository (e.g. "kubernetes/kubernetes" which refers to
https://github.com/kubernetes/kubernetes/), fetch all of that project's contributors, and then fetch
each contributor's repositories. Count how many times each repository appears across all contributors.
Then print to stdout a summary of the top 10 repositories by count.

## Installation

If this gem is published to ruby gems:

    $ gem install github_crawl

## Usage

Change to a temporary directory where the crawler can write a Sqlite database
and any other temporary results, e.g.


    $ mkdir -p ~/tmp/github_crawl
    $ cd ~/tmp/github_crawl
    $ github_crawl
    github repo in the form "{owner}/{repo}": kubernetes/kubernetes
    github user: {your user name}
    github pass: *******
    ...
    All results are saved to github_crawl_data/repo_results.json

To run it from a git repository clone, change to a temporary

    $ git clone https://github.com/darrenleeweber/github_crawl.git
    $ bundle install  # assumes `gem install bundler`
    $ bundle exec ./exe/github_crawl 
    github repo in the form "{owner}/{repo}": kubernetes/kubernetes
    github user: {your user name}
    github pass: *******
    ...
    All results are saved to github_crawl_data/repo_results.json

Responses to prompts are optional (a RETURN is acceptable).  Environment variables can be
set to skip the prompts each time, i.e.

    $ export GITHUB_SQL={true | false} # Sqlite store is disabled by default
    $ export GITHUB_USER={user_name}
    $ export GITHUB_PASS={user_password}
    $ export GITHUB_REPO="{owner}/{repo}"
    $ github_crawl

A github user login:pass allows authenticated github API requests.  The authentication is
optional, but recommended because the github API rate limit is much higher with authentication.
The github user:pass does not need to be an authorized committer on a repository to crawl it.
Without a github repository to begin with, it defaults to "kubernetes/kubernetes".

## Development

After checking out the repo, run `bin/setup` to install dependencies.
Then, run `rake spec` to run the tests. You can also run `bin/console`
for an interactive prompt that will allow you to experiment, e.g.

    $ bundle exec bin/console 
    [1] pry(main)> GithubCrawl::VERSION
    => "0.1.0"

To install this gem onto your local machine, run `bundle exec rake install`.
To release a new version, update the version number in `version.rb`, and then
run `bundle exec rake release`, which will create a git tag for the version,
push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

### References

- https://developer.github.com/v3/libraries/
- https://developer.github.com/v3/#rate-limiting
  - 5000 requests per hour, if authenticated

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/darrenleeweber/github_crawl.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
