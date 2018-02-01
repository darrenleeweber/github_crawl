RSpec.describe GithubCrawl::Repo, :vcr do
  let(:repo) { described_class.new('kubernetes/kubernetes') }

  describe '#new' do
    it 'works' do
      expect(repo).to be_a described_class
    end
  end

  describe '#contributors' do
    it 'works' do
      expect(repo.contributors).to be_an Array
      expect(repo.contributors.first).to be_a String
    end
  end
end
