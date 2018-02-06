RSpec.describe GithubCrawl::GithubRepo, :vcr do
  subject(:repo) { described_class.new(full_name: full_name) }

  let(:full_name) { 'kubernetes/kubernetes' }
  let(:github_repo) do
    json = File.read('spec/fixtures/repos/kubernetes.json')
    Sawyer::Resource.new(Octokit.agent, JSON.parse(json))
  end

  describe '#new' do
    it 'works' do
      expect(repo).to be_a described_class
    end

    context 'with full_name' do
      it 'fetches github data' do
        expect(Octokit).to receive(:repo).and_return(github_repo)
        described_class.new(full_name: full_name)
      end
    end

    context 'with github repo' do
      it 'does not fetch github data' do
        expect(Octokit).not_to receive(:repo)
        described_class.new(repo: github_repo)
      end
    end
  end

  describe '#contributors' do
    it 'is an Array<GithubCrawl::User>' do
      expect(repo.contributors).to be_an Array
      expect(repo.contributors.first).to be_a GithubCrawl::GithubUser
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
