RSpec.describe GithubCrawl::SqlUsers, :vcr do
  subject(:sql_users) { described_class.new(db: test_db) }

  let(:test_db) { GithubCrawl::SqlDb.new('github_test.db').db }
  let(:table_name) { sql_users.table_name }
  let(:create_table) { sql_users.send(:create_table) }
  let(:drop_table) { sql_users.send(:drop_table) }

  let(:user) do
    user_json = File.read('spec/fixtures/users/liggitt.json')
    agent = Sawyer::Agent.new('https://api.github.com/',
                              links_parser: Sawyer::LinkParsers::Simple.new)
    Sawyer::Resource.new(agent, JSON.parse(user_json))
  end
  let(:login) { user[:login] }

  before do
    drop_table
    create_table
  end

  describe '#new' do
    it 'works' do
      expect(sql_users).not_to be_nil
    end
  end

  context 'user record does not exist' do
    describe '#exists?' do
      it 'returns false' do
        expect(sql_users.exists?(login)).to eq false
      end
    end
    describe '#create' do
      it 'works' do
        expect { sql_users.create(user) }.to change { sql_users.exists?(login) }
      end
    end
    describe '#read' do
      it 'works' do
        expect(sql_users.read(login)).to be_nil
      end
    end
    describe '#update' do
      it 'works' do
        expect(sql_users.update(user)).to eq false
      end
    end
    describe '#delete' do
      it 'works' do
        expect { sql_users.delete(user) }.not_to change { sql_users.exists?(login) }
      end
    end
  end

  context 'user record exists' do
    before do
      sql_users.create(user)
    end

    describe '#exists?' do
      it 'returns true' do
        expect(sql_users.exists?(login)).to eq true
      end
    end

    describe '#create' do
      it 'works' do
        expect { sql_users.create(user) }.not_to change { sql_users.exists?(login) }
      end
    end

    describe '#read' do
      it 'works' do
        expect(sql_users.read(login)).to be_a Sawyer::Resource
      end
      it 'returns a useful resource' do
        user_resource = sql_users.read(login)
        expect { user_resource.rels[:repos].get.data }.not_to raise_error
      end
    end

    describe '#update' do
      it 'works' do
        expect(sql_users.update(user)).to eq true
      end
    end
    describe '#delete' do
      it 'works' do
        expect { sql_users.delete(user) }.to change { sql_users.exists?(login) }
      end
    end
  end
end
