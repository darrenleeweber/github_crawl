module GithubCrawl
  # A Github repository
  class GithubRepo
    attr_reader :repo

    # @param [String] full_name in the form "{owner}/{repo}"
    # @param [Sawyer::Resource] repo data from github
    def initialize(full_name: nil, repo: nil)
      init_repo(repo)
      init_full_name(full_name)
      raise "Cannot locate repo #{full_name}" if @repo.nil?
    rescue StandardError => err
      log_error(err)
    end

    # Retrieve all the contributors to this repository.
    # Note: there is no way to identify all the contributors without
    # requesting them every time; it might be possible to use a SQL cache
    # at the risk of using stale data.  An HTTP-CACHE is a better option,
    # because it can use E-tags to validate the cache.
    # @return [Array<GithubUser>] github users
    def contributors
      @contributors ||= begin
        users = GithubCrawl.link_data(repo.rels[:contributors])
        users.map { |user| GithubCrawl::GithubUser.new(user: user) }
      end
    rescue StandardError => err
      log_error(err)
    end

    def full_name
      repo[:full_name]
    end

    def name
      repo[:name]
    end

    private

    # @param [String] full_name
    # @return [void]
    def init_full_name(full_name)
      return unless full_name.is_a?(String)
      @repo ||= Octokit.repo(full_name)
    end

    # @param [Sawyer::Resource] repo
    # @return [void]
    def init_repo(repo)
      return unless repo.is_a?(Sawyer::Resource)
      @repo ||= repo
    end

    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
