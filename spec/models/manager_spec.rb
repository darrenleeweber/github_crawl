require 'models/manager'

RSpec.describe Models::Manager, :vcr do

  let(:repo) do
    json = File.read('spec/fixtures/repos/kubernetes.json')
    resource = Sawyer::Resource.new(Octokit.agent, JSON.parse(json))
    GithubCrawl::GithubRepo.new(repo: resource)
  end

  let(:user) do
    user_json = File.read('spec/fixtures/users/liggitt.json')
    resource = Sawyer::Resource.new(Octokit.agent, JSON.parse(user_json))
    GithubCrawl::GithubUser.new(user: resource)
  end

  before { Models.create_tables }
  after { Models.drop_tables }

  describe '#persist_repo' do
    it 'works' do
      expect { Models::Manager.persist_repo(repo) }.to change { Models::Repo.count }
    end
  end

  describe '#persist_user' do
    it 'works' do
      expect { Models::Manager.persist_user(user) }.to change { Models::User.count }
    end
  end
end
