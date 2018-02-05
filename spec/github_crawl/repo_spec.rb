RSpec.describe GithubCrawl::Repo, :vcr do
  subject(:repo) { described_class.new(full_name: full_name) }

  let(:full_name) { 'kubernetes/kubernetes' }
  let(:github_repo) do
    json = File.read('spec/fixtures/repos/kubernetes.json')
    agent = Sawyer::Agent.new('https://api.github.com/',
                              links_parser: Sawyer::LinkParsers::Simple.new)
    Sawyer::Resource.new(agent, JSON.parse(json))
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
      expect(repo).to be_a described_class
    end

    context 'with full_name' do
      it 'checks SQL' do
        expect(sql_repo).to receive(:read).and_return(nil)
        described_class.new(full_name: full_name)
      end
      it 'if SQL works, does not fetch from github' do
        sql_repo.create(github_repo)
        expect(Octokit).not_to receive(:repo)
        described_class.new(full_name: full_name)
      end
      it 'fetches github data' do
        expect(Octokit).to receive(:repo).and_call_original
        expect(repo).to be_a described_class
      end
    end

    context 'with github repo' do
      let(:repo_with_repo) { described_class.new(repo: github_repo) }

      it 'does not fetch github data' do
        expect(Octokit).not_to receive(:repo)
        expect(repo_with_repo).to be_a described_class
      end
      it 'does not read SQL' do
        expect(sql_repo).not_to receive(:read)
        expect(repo_with_repo).to be_a described_class
      end
      it 'saves SQL' do
        expect(sql_repo).to receive(:create)
        expect(repo_with_repo).to be_a described_class
      end
    end
  end

  describe '#contributors' do
    it 'is an Array<GithubCrawl::User>' do
      expect(repo.contributors).to be_an Array
      expect(repo.contributors.first).to be_a GithubCrawl::User
    end
  end

  describe '#full_name' do
    it 'works' do
      expect(repo.full_name).to eq full_name
    end
  end

  describe '#name' do
    it 'works' do
      expect(repo.name).to eq full_name.split('/').last
    end
  end
end
