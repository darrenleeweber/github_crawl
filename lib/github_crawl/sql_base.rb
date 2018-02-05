require_relative 'sql_models'
require_relative 'sql_serializer'

module GithubCrawl
  # Base class for SQL tables
  class SqlBase
    include GithubCrawl::SqlModels
    include GithubCrawl::SqlSerializer

    attr_accessor :db
    attr_accessor :table_name

    def initialize(db: nil, table_name: nil)
      @db = db || GithubCrawl.sql_conn.conn
      @table_name = table_name
    end

    # @return [Array]
    def all
      dataset.all
    end

    # @return [Sequel::SQLite::Dataset]
    def dataset
      db[table_name]
    end

    # @return [Array<Array<Symbol, Hash>>]
    def schema
      db.schema table_name
    end
  end
end
