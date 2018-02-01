RSpec.describe GithubCrawl::User, :vcr do
  let(:user) { described_class.new('liggitt') }

  describe '#new' do
    it 'works' do
      expect(user).to be_a described_class
    end
  end

  describe '#repos' do
    it 'works' do
      expect(user.repos).to be_an Array
      expect(user.repos.first).to be_a String
    end
  end
end
