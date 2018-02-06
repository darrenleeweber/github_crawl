require 'logger'
require 'sequel'

module Models
  # A Sqlite database connection
  class Conn
    attr_accessor :conn

    def initialize(db_name = 'github_crawl.sqlite')
      path = File.join(Models::DATA_PATH, db_name)
      @conn = Sequel.connect("sqlite://#{path}")
      @conn.loggers << logger
      @conn.extension(:pagination)
      @conn.test_connection
    end

    private

    def logger
      logger = Logger.new(log_device, 'weekly')
      logger.level = Logger::INFO
      logger
    end

    # @return [File] log device
    def log_device
      begin
        log_file = File.absolute_path(File.join(Models::DATA_PATH, 'sql.log'))
        begin
          FileUtils.mkdir_p File.dirname(log_file)
        rescue StandardError
          nil
        end
        log_dev = File.new(log_file, 'w+')
      rescue StandardError
        log_dev = $stderr
      end
      log_dev
    end
  end
end
