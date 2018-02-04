RSpec.describe GithubCrawl::SqlConn do
  subject(:conn) { described_class.new('github_test.sqlite') }

  describe '#new' do
    it 'works' do
      expect(conn).to be_a described_class
    end
  end
  describe '#conn' do
    it 'is a Sequel::SQLite::Database' do
      expect(conn.conn).to be_a Sequel::SQLite::Database
    end
  end
end
