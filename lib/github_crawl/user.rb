module GithubCrawl

  # A Github user
  class User

    # @param [String] login for user
    def initialize(login)
      # @user = db_read(login)
      @user ||= fetch_user(login)
      raise "Cannot locate user: #{login}" if @user.nil?
    rescue StandardError => err
      log_error(err)
    end

    # @return [Array<String>]
    def repos
      user.rels[:repos].get.data.map(&:full_name)
    rescue StandardError => err
      log_error(err)
    end

    private

    attr_reader :user

    # @param [String] login for user
    # @return [Sawyer::Resource] user
    def fetch_user(login)
      user = Octokit.user(login)
      db_save(user) unless user.nil?
      user
    end

    # @param [String] login for user
    # @return [Sawyer::Resource] user
    def db_read(login)
      GithubCrawl::DB[login]
    end

    # @return [Sawyer::Resource] user
    # @return [void]
    def db_save(user)
      GithubCrawl::DB.lock do
        GithubCrawl::DB.set! user[:login], user.to_h
      end
    end

    # @return [void]
    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
