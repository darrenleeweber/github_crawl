module GithubCrawl
  # A Github user
  class User
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
    # @return [Array<Sawyer::Resource>]
    def repos
      @repos ||= begin
        data = GithubCrawl.link_data(user.rels[:repos])
        data.map { |repo| GithubCrawl::Repo.new(repo: repo) }
      end
    rescue StandardError => err
      log_error(err)
    end

    private

    # @param [String] login
    # @return [void]
    def init_login(login)
      return unless login.is_a?(String)
      @user ||= model.read(login) if GithubCrawl.sql_enabled?
      @user ||= fetch_user(login)
    end

    # @param [Sawyer::Resource] user
    # @return [void]
    def init_user(user)
      return unless user.is_a?(Sawyer::Resource)
      @user = user
      model.save(@user) if GithubCrawl.sql_enabled?
    end

    # @param [String] login for user
    # @return [Sawyer::Resource, nil] user
    def fetch_user(login)
      user = Octokit.user(login)
      model.save(user) if GithubCrawl.sql_enabled?
      user
    end

    def model
      @model ||= GithubCrawl::SqlUsers.new
    end

    # @return [void]
    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
