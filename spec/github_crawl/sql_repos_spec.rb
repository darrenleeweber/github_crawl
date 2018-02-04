RSpec.describe GithubCrawl::SqlRepos, :vcr do
  subject(:sql_repos) { described_class.new(test_db) }

  let(:test_db) { TEST_SQL_CONN.conn }
  let(:table_name) { sql_repos.table_name }
  let(:create_table) { sql_repos.create_repos }
  let(:drop_table) { sql_repos.drop_table(table_name) }

  let(:repo) do
    json = File.read('spec/fixtures/repos/kubernetes.json')
    agent = Sawyer::Agent.new('https://api.github.com/',
                              links_parser: Sawyer::LinkParsers::Simple.new)
    Sawyer::Resource.new(agent, JSON.parse(json))
  end
  let(:full_name) { repo[:full_name] }

  before { create_table }
  after { drop_table }

  describe '#new' do
    it 'works' do
      expect(sql_repos).not_to be_nil
    end
  end

  context 'repo record does not exist' do
    describe '#exists?' do
      it 'returns false' do
        expect(sql_repos.exists?(full_name)).to eq false
      end
    end
    describe '#create' do
      it 'works' do
        expect { sql_repos.create(repo) }.to change { sql_repos.exists?(full_name) }
      end
    end
    describe '#read' do
      it 'works' do
        expect(sql_repos.read(full_name)).to be_nil
      end
    end
    describe '#update' do
      it 'works' do
        expect(sql_repos.update(repo)).to eq false
      end
    end
    describe '#delete' do
      it 'works' do
        expect { sql_repos.delete(repo) }.not_to change { sql_repos.exists?(full_name) }
      end
    end
  end

  context 'repo record exists' do
    before do
      sql_repos.create(repo)
    end

    describe '#exists?' do
      it 'returns true' do
        expect(sql_repos.exists?(full_name)).to eq true
      end
    end

    describe '#create' do
      it 'works' do
        expect { sql_repos.create(repo) }.not_to change { sql_repos.exists?(full_name) }
      end
    end

    describe '#read' do
      it 'works' do
        expect(sql_repos.read(full_name)).to be_a Sawyer::Resource
      end
      it 'returns a useful resource' do
        repo_resource = sql_repos.read(full_name)
        expect { repo_resource.rels[:contributors].get.data }.not_to raise_error
      end
    end

    describe '#update' do
      it 'works' do
        expect(sql_repos.update(repo)).to eq true
      end
    end
    describe '#delete' do
      it 'works' do
        expect { sql_repos.delete(repo) }.to change { sql_repos.exists?(full_name) }
      end
    end
  end
end
