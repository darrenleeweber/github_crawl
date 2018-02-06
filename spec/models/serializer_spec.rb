require 'models/serializer'

RSpec.describe Models::Serializer do
  subject(:serializer) { Models::Serializer }

  let(:resource) do
    user_json = File.read('spec/fixtures/users/liggitt.json')
    Sawyer::Resource.new(Octokit.agent, JSON.parse(user_json))
  end

  describe '#serialize' do
    it 'returns JSON' do
      expect(serializer.serialize(resource)).to be_a String
    end
  end

  describe '#deserialize' do
    it 'returns a Sawyer::Resource' do
      dumped = serializer.serialize(resource)
      expect(serializer.deserialize(dumped)).to be_a Sawyer::Resource
    end
  end

  describe '#marshal_dump' do
    it 'returns a Marshal.dump String' do
      expect(serializer.marshal_dump(resource)).to be_a String
    end
  end

  describe '#marshal_load' do
    it 'returns a Sawyer::Resource' do
      dumped = serializer.marshal_dump(resource)
      expect(serializer.marshal_load(dumped)).to be_a Sawyer::Resource
    end
  end
end
