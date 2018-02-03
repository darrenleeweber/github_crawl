RSpec.describe GithubCrawl do
  it 'has a version number' do
    expect(GithubCrawl::VERSION).not_to be nil
  end

  describe '.check_rate_limit', :vcr do
    before do
      # retrieve some data first
      GithubCrawl::User.new(login: 'liggitt')
    end
    it 'inspects the rate limit headers' do
      expect(Octokit).to receive(:last_response).and_call_original
      GithubCrawl.check_rate_limit
    end
  end
end
