module GithubCrawl

  # A Github repository
  class Repo

    # @param [String] repo_name in the form "{owner}/{repo}"
    def initialize(repo_name)
      # @repo = db_read(repo_name)
      @repo ||= fetch_repo(repo_name)
      raise "Cannot locate repo: #{repo_name}" unless full_name == repo_name
    rescue StandardError => err
      log_error(err)
    end

    # @return [Array<String>] user logins
    def contributors
      repo.rels[:contributors].get.data.map(&:login)
    rescue StandardError => err
      log_error(err)
    end

    def full_name
      repo[:full_name]
    end

    private

    attr_reader :repo

    # @param [String] repo_name in the form "{owner}/{repo}"
    def fetch_repo(repo_name)
      repo = Octokit.repo(repo_name)
      db_save(repo) unless repo.nil?
      repo
    end

    # @param [String] repo_name in the form "{owner}/{repo}"
    # @return [Sawyer::Resource] repo
    def db_read(repo_name)
      GithubCrawl::DB[repo_name]
    end

    # @param [Sawyer::Resource] repo
    # @return [void]
    def db_save(repo)
      GithubCrawl::DB.lock do
        GithubCrawl::DB.set! repo[:full_name], repo.to_h
      end
    rescue StandardError => err
      log_error(err)
    end

    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
