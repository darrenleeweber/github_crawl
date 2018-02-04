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
      raise 'Cannot locate user' if @user.nil?
    rescue StandardError => err
      log_error(err)
    end

    def login
      user[:login]
    end

    # @return [Array<Sawyer::Resource>]
    def repos
      @repos ||= begin
        data = GithubCrawl.link_data(user, :repos)
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
      @user ||= db_read(login)
      @user ||= fetch_user(login)
    end

    # @param [Sawyer::Resource] user
    # @return [void]
    def init_user(user)
      return unless user.is_a?(Sawyer::Resource)
      @user = user
      db_save(@user)
    end

    # @param [String] login for user
    # @return [Sawyer::Resource, nil] user
    def fetch_user(login)
      user = Octokit.user(login)
      db_save(user) unless user.nil?
      user
    end

    # @param [String] login for user
    # @return [Sawyer::Resource, nil] user
    def db_read(login)
      # TODO: disabled until the deserialization works correctly
      return nil
      model.read(login)
    end

    # @param [Sawyer::Resource] user
    # @return [void]
    def db_save(user)
      # TODO: disabled until the deserialization works correctly
      return nil
      if model.exists?(user[:login])
        model.update(user)
      else
        model.create(user)
      end
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
