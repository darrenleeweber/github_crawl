# GithubCrawl

This is a command-line script to crawl Github user profiles.

Given the full name of a target github repository (e.g. "kubernetes/kubernetes" which refers to
https://github.com/kubernetes/kubernetes/), fetch all of that project's contributors, and then fetch
each contributor's repositories. Count how many times each repository appears across all contributors.
Then print to stdout a summary of the top 10 repositories by count.

## Installation

    $ gem install github_crawl

## Usage

    $ github_crawl {repo_name}

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
  - 5000 requests per hour

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/darrenleeweber/github_crawl.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
