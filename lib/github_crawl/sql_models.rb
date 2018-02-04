require 'sequel'

module GithubCrawl
  # A Sqlite database, using Sequel
  # @see http://sequel.jeremyevans.net/documentation.html Sequel RDoc
  # @see http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html Sequel Readme
  # @see http://sequel.jeremyevans.net/rdoc/files/doc/code_order_rdoc.html Sequel code order
  module SqlModels

    # Create :repos table, unless it exists
    def create_repos
      db.create_table? :repos do
        primary_key :id
        String :full_name, unique: true, null: false
        Blob :data
        index [:full_name]
      end
    rescue Sequel::DatabaseError
      log_error('failed to create table: repos')
    end

    # Create :users table, unless it exists
    def create_users
      db.create_table? :users do
        primary_key :id
        String :login, unique: true, null: false
        Blob :data
        index [:login]
      end
    rescue Sequel::DatabaseError
      log_error('failed to create table: users')
    end

    # Drop table_name, if it exists
    # @param [Symbol] table_name
    def drop_table(table_name)
      db.drop_table? table_name
    rescue Sequel::DatabaseError
      log_error('failed to drop table: ' + table_name)
    end

    # @param [String] err
    # @return [void]
    def log_error(err)
      STDERR.write "#{err}\n"
      STDERR.flush
    end
  end
end
