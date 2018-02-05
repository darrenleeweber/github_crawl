require 'sequel'
require 'sqlite3'

require 'models/conn'

# Sequel custom serializers
require 'models/serializer'
require 'sequel/plugins/serialization'
serializer = ->(data) { Models::Serializer.serialize(data) }
deserializer = ->(blob) { Models::Serializer.deserialize(blob) }
Sequel::Plugins::Serialization.register_format(:sawyer, serializer, deserializer)

# Sqlite database, using Sequel
# @see http://sequel.jeremyevans.net/documentation.html Sequel RDoc
# @see http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html Sequel Readme
# @see http://sequel.jeremyevans.net/rdoc/files/doc/code_order_rdoc.html Sequel code order
module Models
  DATA_PATH = 'github_crawl_data'.freeze

  def self.included(_base)
    create_tables
    require 'models/repo'
    require 'models/user'
    require 'models/manager'
  end

  def self.db
    @@db ||= Models::Conn.new.conn
  end

  def self.set_db(db)
    @@db = db
  end

  # Create tables
  def self.create_tables
    create_repos
    create_users
    create_repos_users
  end

  # Drop tables
  def self.drop_tables
    drop_table(:repos_users)
    drop_table(:repos)
    drop_table(:users)
  end

  # Create :repos table, unless it exists
  def self.create_repos
    db.create_table? :repos do
      primary_key :id
      String :full_name, unique: true, null: false
      String :name
      Blob :data
      index [:full_name]
    end
  rescue Sequel::DatabaseError
    logger.error('failed to create table: repos')
  end

  # Create :users table, unless it exists
  def self.create_users
    db.create_table? :users do
      primary_key :id
      String :login, unique: true, null: false
      Blob :data
      index [:login]
    end
  rescue Sequel::DatabaseError
    logger.error('failed to create table: users')
  end

  def self.create_repos_users
    db.create_join_table?(repo_id: :repos, user_id: :users)
  end

  # Drop table_name, if it exists
  # @param [Symbol] table_name
  def self.drop_table(table_name)
    db.drop_table? table_name
  rescue Sequel::DatabaseError
    logger.error('failed to drop table: ' + table_name)
  end

  # @param [Symbol] table_name
  # @return [Array<Array<Symbol, Hash>>]
  def self.schema(table_name)
    db.schema table_name
  end

  def self.logger
    @@logger ||= begin
      log_file = File.absolute_path(File.join(Models::DATA_PATH, 'models.log'))
      log_device = File.new(log_file, 'w+')
      logger = Logger.new(log_device, 'weekly')
      logger.level = Logger::INFO
      logger
    end
  end
end
