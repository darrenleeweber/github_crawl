require_relative 'sql_base'

module GithubCrawl
  # User table
  class SqlUsers < SqlBase
    def initialize(db = nil)
      super(db: db, table_name: :users)
      create_users
    end

    # @param [String] login
    # @return [Boolean]
    def exists?(login)
      user = dataset[login: login]
      !user.nil?
    end

    # @param [Sawyer::Resource] user
    # @return [Integer, nil] user.id (nil if it exists, use update instead)
    def create(user)
      return if exists? user[:login]
      dataset.insert(login: user[:login], data: serialize(user))
    end

    # @param [String] login
    # @return [Sawyer::Resource, nil] user (nil if it doesn't exist)
    def read(login)
      user = dataset[login: login]
      deserialize(user[:data]) unless user.nil?
    end

    # @param [Sawyer::Resource] user
    # @return [Boolean]
    def save(user)
      return false if user.nil?
      if exists?(user[:login])
        update(user)
      else
        create(user)
      end
    end

    # @param [Sawyer::Resource] user
    # @return [Boolean]
    def update(user)
      result = dataset.where(login: user[:login]).update(data: serialize(user))
      result > 0
    end

    # @param [Sawyer::Resource] user
    # @return [void]
    def delete(user)
      dataset.where(login: user[:login]).delete
    end
  end
end
