module GithubCrawl

  # A Github repository
  class Repo

    attr_reader :repo

    # @param [String] full_name in the form "{owner}/{repo}"
    # @param [Sawyer::Resource] repo data from github
    def initialize(full_name: nil, repo: nil)
      if repo.is_a?(Sawyer::Resource)
        @repo = repo
        # db_save(@repo)
      elsif full_name.is_a?(String)
        @repo = db_read(full_name)
        @repo ||= fetch_repo(full_name)
      end
      raise 'Cannot locate repo' if @repo.nil?
    rescue StandardError => err
      log_error(err)
    end

    # @return [Array<GithubCrawl::User>] github users
    def contributors
      @contributors ||= begin
        response = repo.rels[:contributors].get
        data = response.data
        while response.rels[:next]
          response = response.rels[:next].get
          data.concat response.data
        end
        data.map { |user| GithubCrawl::User.new(user: user) }
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

    # @param [String] repo_name in the form "{owner}/{repo}"
    # @return [Sawyer::Resource, nil] repo resource
    def fetch_repo(repo_name)
      repo = Octokit.repo(repo_name)
      db_save(repo) unless repo.nil?
      repo
    end

    # @param [String] full_name for repo
    # @return [Sawyer::Resource, nil] repo
    def db_read(full_name)
      # TODO: disabled until the deserialization works correctly
      return nil
      model.read(full_name)
    end

    # @param [Sawyer::Resource] repo
    # @return [void]
    def db_save(repo)
      # TODO: disabled until the deserialization works correctly
      return nil
      if model.exists?(repo[:full_name])
        model.update(repo)
      else
        model.create(repo)
      end
    rescue StandardError => err
      log_error(err)
    end

    def model
      @model ||= GithubCrawl::SqlRepos.new
    end

    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
