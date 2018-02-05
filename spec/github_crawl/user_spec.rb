RSpec.describe GithubCrawl::User, :vcr do
  subject(:user) { described_class.new(login: login) }

  let(:login) { 'liggitt' }
  let(:github_user) do
    user_json = File.read('spec/fixtures/users/liggitt.json')
    agent = Sawyer::Agent.new('https://api.github.com/',
                              links_parser: Sawyer::LinkParsers::Simple.new)
    Sawyer::Resource.new(agent, JSON.parse(user_json))
  end

  let(:sql_user) { GithubCrawl::SqlUsers.new(test_db) }
  let(:sql_repo) { GithubCrawl::SqlRepos.new(test_db) }
  let(:test_db) { TEST_SQL_CONN.conn }

  before do
    allow(GithubCrawl::SqlRepos).to receive(:new).and_return(sql_repo)
    allow(GithubCrawl::SqlUsers).to receive(:new).and_return(sql_user)
    sql_repo.drop_table(:repos)
    sql_repo.create_repos
    sql_user.drop_table(:users)
    sql_user.create_users
  end

  describe '#new' do
    it 'works' do
      expect(user).to be_a described_class
    end

    context 'with login' do
      it 'checks SQL' do
        expect(sql_user).to receive(:read).and_return(nil)
        described_class.new(login: login)
      end
      it 'if SQL works, does not fetch from github' do
        sql_user.create(github_user)
        expect(Octokit).not_to receive(:user)
        described_class.new(login: login)
      end
      it 'fetches github data' do
        expect(Octokit).to receive(:user).and_call_original
        expect(user).to be_a described_class
      end
    end

    context 'with github user' do
      let(:user_with_user) { described_class.new(user: github_user) }

      it 'does not fetch github data' do
        expect(Octokit).not_to receive(:user)
        expect(user_with_user).to be_a described_class
      end
      it 'does not read SQL' do
        expect(sql_user).not_to receive(:read)
        expect(user_with_user).to be_a described_class
      end
      it 'saves SQL' do
        expect(sql_user).to receive(:create)
        expect(user_with_user).to be_a described_class
      end
    end
  end

  describe '#login' do
    it 'is a user login' do
      expect(user.login).to eq login
    end
  end

  describe '#repos' do
    it 'is an Array<GithubCrawl::Repo>' do
      expect(user.repos).to be_an Array
      expect(user.repos.first).to be_a GithubCrawl::Repo
    end
  end
end
