require 'logger'
require 'sequel'

module GithubCrawl
  # A Sqlite database, using Sequel
  # @see http://sequel.jeremyevans.net/documentation.html Sequel RDoc
  # @see http://sequel.jeremyevans.net/rdoc/files/README_rdoc.html Sequel Readme
  # @see http://sequel.jeremyevans.net/rdoc/files/doc/code_order_rdoc.html Sequel code order
  class SqlConn
    attr_accessor :conn

    def initialize(db_name = nil)
      db_name ||= 'github_crawl.sqlite'
      path = File.join(GithubCrawl::DATA_PATH, db_name)
      @conn = Sequel.connect("sqlite://#{path}")
      @conn.loggers << logger
      @conn.extension(:pagination)
      @conn.test_connection
    end

    private

    def logger
      logger = Logger.new(log_device, 'weekly')
      logger.level = @debug ? Logger::DEBUG : Logger::INFO
      logger
    end

    # @return [File] log device
    def log_device
      begin
        log_file = File.absolute_path(File.join(GithubCrawl::DATA_PATH, 'sql.log'))
        begin
          FileUtils.mkdir_p File.dirname(log_file)
        rescue StandardError
          nil
        end
        log_dev = File.new(log_file, 'w+')
      rescue StandardError
        log_dev = $stderr
      end
      log_dev.sync = true if @debug # skip IO buffering in debug mode
      log_dev
    end
  end
end
