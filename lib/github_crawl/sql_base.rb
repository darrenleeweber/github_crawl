module GithubCrawl
  # Base class for SQL tables
  class SqlBase
    attr_accessor :db
    attr_accessor :table_name

    def initialize(db: GithubCrawl::DB.db, table_name: nil)
      @db = db
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

    private

    def serialize(resource)
      resource.to_h.to_json
    end

    def deserialize(json)
      agent = Sawyer::Agent.new('https://api.github.com/',
                                links_parser: Sawyer::LinkParsers::Simple.new)
      Sawyer::Resource.new(agent, JSON.parse(json))
    end

    def drop_table
      db.drop_table table_name if db.table_exists? table_name
    rescue Sequel::DatabaseError
      log_error('failed to drop table: ' + table_name)
    end

    # @param [String] err
    # @return [void]
    def log_error(err)
      STDERR.write "#{err.message}\n"
      STDERR.flush
    end
  end
end
