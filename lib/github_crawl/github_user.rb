module GithubCrawl
  # A Github user
  class GithubUser
    attr_reader :user

    # A user can be initialized with data from github or a user login
    # @param [String] login for user
    # @param [Sawyer::Resource] user data from github
    def initialize(login: nil, user: nil)
      init_user(user)
      init_login(login)
      raise "Cannot locate user #{login}" if @user.nil?
    rescue StandardError => err
      log_error(err)
    end

    def login
      user[:login]
    end

    # Retrieve all the repositories for this user.
    # Note: there is no way to identify all the repositories without
    # requesting them every time; it might be possible to use a SQL cache
    # at the risk of using stale data.  An HTTP-CACHE is a better option,
    # because it can use E-tags to validate the cache.
    # @return [Array<GithubRepo>]
    def repos
      @repos ||= begin
        repos = GithubCrawl.link_data(user.rels[:repos])
        repos.map { |repo| GithubCrawl::GithubRepo.new(repo: repo) }
      end
    rescue StandardError => err
      log_error(err)
    end

    private

    # @param [String] login
    # @return [void]
    def init_login(login)
      return unless login.is_a?(String)
      @user ||= Octokit.user(login)
    end

    # @param [Sawyer::Resource] user
    # @return [void]
    def init_user(user)
      return unless user.is_a?(Sawyer::Resource)
      @user ||= user
    end

    # @return [void]
    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
