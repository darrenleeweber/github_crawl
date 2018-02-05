module Models
  module Manager
    # Create or update repo and contributors
    # @param [GithubCrawl::GithubRepo] repo
    # @return [Models::Repo] sql_repo
    def self.persist_repo(repo)
      sql_repo = Models::Repo.find_or_create(full_name: repo.full_name)
      sql_repo.name = repo.name
      sql_repo.data = repo.repo
      sql_repo.save
      repo.contributors.each do |user|
        sql_user = Models::User.find_or_create(login: user.login)
        sql_user.data = user.user
        sql_user.save
        sql_repo.add_user(sql_user)
      end
      sql_repo
    rescue StandardError => err
      Models.logger.error err.message
    end

    # Create or update user and repositories
    # @param [GithubCrawl::GithubUser] user
    # @return [Models::User] sql_user
    def self.persist_user(user)
      sql_user = Models::User.find_or_create(login: user.login)
      sql_user.data = user.user
      sql_user.save
      user.repos.each do |repo|
        sql_repo = Models::Repo.find_or_create(full_name: repo.full_name)
        sql_repo.name = repo.name
        sql_repo.data = repo.repo
        sql_repo.save
        sql_user.add_repo(sql_repo)
      end
      sql_user
    rescue StandardError => err
      Models.logger.error err.message
    end
  end
end
