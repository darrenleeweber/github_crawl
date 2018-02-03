RSpec.describe GithubCrawl do
  it 'has a version number' do
    expect(GithubCrawl::VERSION).not_to be nil
  end

  describe '.rate_limit', :vcr do
    it 'inspects the rate limit data' do
      expect(Octokit).to receive(:rate_limit).and_call_original
      GithubCrawl.rate_limit
    end
  end

  describe '.check_rate_limit', :vcr do
    it 'inspects the rate limit data' do
      expect(Octokit).to receive(:rate_limit).and_call_original
      GithubCrawl.check_rate_limit
    end
  end
end
