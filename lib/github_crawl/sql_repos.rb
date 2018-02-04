module GithubCrawl
  # Repo table
  class SqlRepos < SqlBase
    def initialize(db: GithubCrawl::DB.db)
      super(db: db, table_name: :repos)
      create_table unless db.table_exists? :repos
    end

    # @param [String] full_name
    # @return [Boolean]
    def exists?(full_name)
      repo = dataset[full_name: full_name]
      !repo.nil?
    end

    # @param [Sawyer::Resource] repo
    # @return [Integer, nil] repo.id (nil if it exists, use update instead)
    def create(repo)
      return if exists? repo[:full_name]
      dataset.insert(full_name: repo[:full_name], data: serialize(repo))
    end

    # @param [String] full_name
    # @return [Sawyer::Resource, nil] repo (nil if it doesn't exist)
    def read(full_name)
      repo = dataset[full_name: full_name]
      deserialize(repo[:data]) unless repo.nil?
    end

    # @param [Sawyer::Resource] repo
    # @return [Boolean]
    def update(repo)
      result = dataset.where(full_name: repo[:full_name]).update(data: serialize(repo))
      result > 0
    end

    # @param [Sawyer::Resource] repo
    # @return [void]
    def delete(repo)
      dataset.where(full_name: repo[:full_name]).delete
    end

    private

    def create_table
      db.create_table :repos do
        primary_key :id
        String :full_name, unique: true, null: false
        String :data
        index [:full_name]
      end
    rescue Sequel::DatabaseError
      log_error('failed to create table: ' + table_name)
    end
  end
end
