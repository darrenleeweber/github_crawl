RSpec.describe GithubCrawl::SqlBase do
  subject(:sql_base) { described_class.new(db: test_db, table_name: table_name) }

  let(:test_db) { TEST_SQL_CONN.conn }
  let(:table_name) { :test }

  let(:create_table) do
    test_db.create_table table_name do
      primary_key :id
      String :login, unique: true, null: false
      Blob :data
      index [:login]
    end
  end
  let(:drop_table) do
    test_db.drop_table table_name if test_db.table_exists? table_name
  end

  before do
    drop_table
    create_table
  end

  describe '#new' do
    it 'works' do
      expect(sql_base).to be_a described_class
    end
  end

  describe '#all' do
    it 'works' do
      expect(sql_base.all).to be_an Array
    end
  end

  describe '#dataset' do
    it 'works' do
      expect(sql_base.dataset).to be_a Sequel::SQLite::Dataset
    end
  end

  describe '#schema' do
    it 'works' do
      expect(sql_base.schema).to be_an Array
    end
  end
end
