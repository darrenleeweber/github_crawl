require 'logger'
require 'sequel'

module GithubCrawl

  # A Sqlite database, using Sequel
  # @see http://sequel.jeremyevans.net/documentation.html Sequel RDoc
  # @see http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html Sequel Readme
  # @see http://sequel.jeremyevans.net/rdoc/files/doc/code_order_rdoc.html Sequel code order
  class SqlDb

    attr_accessor :db

    def initialize(db_name = 'github_crawl.db')
      @db = Sequel.connect("sqlite://#{db_name}")
      @db.loggers << logger
      @db.extension(:pagination)
      # Ensure the connection is good on startup, raises exceptions on failure
      logger.info "#{@db} connected: #{@db.test_connection}"
    end

    private

    def logger
      @logger ||= begin
        logger = Logger.new(log_device, 'weekly')
        logger.level = @debug ? Logger::DEBUG : Logger::INFO
        logger
      end
    end

    # @return [File] log device
    def log_device
      begin
        log_file = File.absolute_path 'log/sql.log'
        FileUtils.mkdir_p File.dirname(log_file) rescue nil
        log_dev = File.new(log_file, 'w+')
      rescue
        log_dev = $stderr
      end
      log_dev.sync = true if @debug # skip IO buffering in debug mode
      log_dev
    end

    def log_model_info(m)
      logger.info "table: #{m.table_name}, columns: #{m.columns}, pk: #{m.primary_key}"
    end
  end
end
