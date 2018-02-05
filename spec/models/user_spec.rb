require 'models/user'

RSpec.describe Models::User do
  subject(:sql_user) { described_class.new(login: login, data: user) }

  let(:user) do
    user_json = File.read('spec/fixtures/users/liggitt.json')
    Sawyer::Resource.new(Octokit.agent, JSON.parse(user_json))
  end
  let(:login) { user[:login] }

  before { Models.create_tables }
  after { Models.drop_tables }

  describe '#new' do
    it 'works' do
      expect(sql_user).not_to be_nil
    end
  end

  describe '#login' do
    it 'returns a String' do
      expect(sql_user.login).to eq login
    end
  end

  describe '#data' do
    it 'returns a Sawyer::Resource' do
      expect(sql_user.data).to eq user
    end
  end
end
