RSpec.describe GithubCrawl::User, :vcr do
  subject(:user) { described_class.new(login: login) }

  let(:login) { 'liggitt' }
  let(:github_user) { user.user }

  describe '#new' do
    it 'works' do
      expect(user).to be_a described_class
    end

    context 'with login' do
      it 'fetches github data' do
        expect(Octokit).to receive(:user).and_call_original
        expect(user).to be_a described_class
      end
    end

    context 'with github user' do
      let(:user_with_user) { described_class.new(user: github_user) }

      before do
        user # first fetch the user data
      end

      it 'does not fetch github data' do
        expect(Octokit).not_to receive(:user)
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
