require 'models/repo'

RSpec.describe Models::Repo do
  subject(:sql_repo) { described_class.new(full_name: full_name, name: name, data: repo) }

  let(:repo) do
    json = File.read('spec/fixtures/repos/kubernetes.json')
    Sawyer::Resource.new(Octokit.agent, JSON.parse(json))
  end
  let(:full_name) { repo[:full_name] }
  let(:name) { repo[:name] }

  before { Models.create_tables }
  after { Models.drop_tables }

  describe '#new' do
    it 'works' do
      expect(sql_repo).not_to be_nil
    end
  end

  describe '#full_name' do
    it 'returns a String' do
      expect(sql_repo.full_name).to eq repo[:full_name]
    end
  end

  describe '#name' do
    it 'returns a String' do
      expect(sql_repo.name).to eq repo[:name]
    end
  end

  describe '#data' do
    it 'returns a Sawyer::Resource' do
      expect(sql_repo.data).to eq repo
    end
  end
end
