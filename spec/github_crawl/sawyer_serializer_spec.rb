RSpec.describe GithubCrawl::SawyerSerializer, :vcr do
  subject(:serializer) { test_class.new }

  let(:test_class) { Class.new { include GithubCrawl::SawyerSerializer } }

  let(:resource) { GithubCrawl::User.new(login: 'liggitt').user }

  describe '#serialize' do
    it 'returns a Marshal.dump String' do
      expect(serializer.serialize(resource)).to be_a String
    end
  end

  describe '#deserialize' do
    it 'returns a Sawyer::Resource' do
      dumped = Marshal.dump(resource)
      expect(serializer.deserialize(dumped)).to be_a Sawyer::Resource
    end
  end
end
