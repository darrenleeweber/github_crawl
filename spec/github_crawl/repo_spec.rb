RSpec.describe GithubCrawl::Repo, :vcr do
  subject(:repo) { described_class.new(full_name: 'kubernetes/kubernetes') }

  let(:full_name) { 'kubernetes/kubernetes' }
  let(:github_repo) { repo.repo }

  describe '#new' do
    it 'works' do
      expect(repo).to be_a described_class
    end

    context 'with full_name' do
      it 'fetches github data' do
        expect(Octokit).to receive(:repo).and_call_original
        expect(repo).to be_a described_class
      end
    end

    context 'with github repo' do
      let(:repo_with_repo) { described_class.new(repo: github_repo) }

      before do
        repo # first fetch the data
      end

      it 'does not fetch github data' do
        expect(Octokit).not_to receive(:repo)
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
