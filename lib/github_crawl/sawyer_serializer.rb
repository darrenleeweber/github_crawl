module GithubCrawl

  # Serialize and deserialize Sawyer Resource data
  module SawyerSerializer

    # @param [Sawyer::Resource] sawyer_resource
    # @return [String] serialized data
    def serialize(sawyer_resource)
      # attrs = sawyer_resource.attrs.to_h.to_json
      # rels = sawyer_resource.rels.to_h.to_json
      # fields = sawyer_resource.fields.to_a.to_json
      Marshal.dump(sawyer_resource.marshal_dump)
    end

    # @param [String] serialized data
    # @return [Sawyer::Resource] sawyer_resource
    def deserialize(dumped)
      agent = Sawyer::Agent.new('https://api.github.com/',
                                links_parser: Sawyer::LinkParsers::Simple.new)
      resource = Sawyer::Resource.new(agent)
      resource.marshal_load(Marshal.restore(dumped))
      resource
    end
  end
end
