module GithubCrawl

  # A Github user
  class User

    attr_reader :user

    # A user can be initialized with data from github or a user login
    # @param [String] login for user
    # @param [Sawyer::Resource] user data from github
    def initialize(login: nil, user: nil)
      if user.is_a?(Sawyer::Resource)
        @user = user
        db_save(@user)
      elsif login.is_a?(String)
        @user = db_read(login)
        @user ||= fetch_user(login)
      end
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
        response = user.rels[:repos].get
        data = response.data
        while response.rels[:next]
          response = response.rels[:next].get
          data.concat response.data
        end
        data.map { |repo| GithubCrawl::Repo.new(repo: repo) }
      end
    rescue StandardError => err
      log_error(err)
    end

    private

    # @param [String] login for user
    # @return [Sawyer::Resource, nil] user
    def fetch_user(login)
      user = Octokit.user(login)
      db_save(user) unless user.nil?
      user
    end

    # The Etag for the last response
    # @return [String] etag
    def fetch_etag
      Octokit.last_response.headers['etag']
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
      # TODO: store and check the Etag cache value
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
