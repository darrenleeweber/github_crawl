RSpec.describe GithubCrawl::SqlDb do
  subject(:sql_db) { described_class.new('github_test.db') }

  describe '#new' do
    it 'works' do
      expect(sql_db).to be_a described_class
    end
  end
end
