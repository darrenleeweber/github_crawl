
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'github_crawl/version'

Gem::Specification.new do |spec|
  spec.name          = 'github_crawl'
  spec.version       = GithubCrawl::VERSION
  spec.authors       = ['Darren L. Weber']
  spec.email         = ['dweber.consulting@gmail.com']

  spec.summary       = 'This is a command-line script to crawl Github user profiles'
  spec.homepage      = 'https://github.com/darrenleeweber/github_crawl'
  spec.license       = 'MIT'

  # Prevent pushing this gem to RubyGems.org. To allow pushes either set the 'allowed_push_host'
  # to allow pushing to a single host or delete this section to allow pushing to any host.
  if spec.respond_to?(:metadata)
    spec.metadata['allowed_push_host'] = "TODO: Set to 'http://mygemserver.com'"
  else
    raise 'RubyGems 2.0 or newer is required to protect against public gem pushes.'
  end

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_dependency 'activesupport'
  spec.add_dependency 'faraday-http-cache'
  spec.add_dependency 'highline'
  spec.add_dependency 'octokit', '~> 4.0'
  spec.add_dependency 'pry'
  spec.add_dependency 'pry-doc'
  spec.add_dependency 'sequel'
  spec.add_dependency 'sqlite3'

  spec.add_development_dependency 'bundler', '~> 1.16'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rspec', '~> 3.0'
  spec.add_development_dependency 'simplecov'
  spec.add_development_dependency 'vcr'
  spec.add_development_dependency 'webmock'
end
