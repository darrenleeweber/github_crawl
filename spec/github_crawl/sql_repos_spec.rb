RSpec.describe GithubCrawl::SqlRepos, :vcr do
  subject(:sql_repos) { described_class.new(db: test_db) }

  let(:test_db) { GithubCrawl::SqlDb.new('github_test.db').db }
  let(:table_name) { sql_repos.table_name }
  let(:create_table) { sql_repos.send(:create_table) }
  let(:drop_table) { sql_repos.send(:drop_table) }

  let(:repo) do
    json = File.read('spec/fixtures/repos/kubernetes.json')
    agent = Sawyer::Agent.new('https://api.github.com/',
                              links_parser: Sawyer::LinkParsers::Simple.new)
    Sawyer::Resource.new(agent, JSON.parse(json))
  end
  let(:full_name) { repo[:full_name] }

  before do
    drop_table
    create_table
  end

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
