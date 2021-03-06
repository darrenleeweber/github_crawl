require 'json'
require 'octokit'
require 'sawyer'

module Models
  # Serialize and deserialize Sawyer Resource data
  module Serializer
    # @param [Sawyer::Resource] resource
    # @return [String] serialized data
    def self.serialize(resource)
      resource.to_h.to_json
    end

    # @param [String] json data
    # @return [Sawyer::Resource] resource
    def self.deserialize(json)
      Sawyer::Resource.new(Octokit.agent, JSON.parse(json))
    end

    # @param [Sawyer::Resource] resource
    # @return [String] serialized data
    def self.marshal_dump(resource)
      # attrs = resource.attrs.to_h.to_json
      # rels = resource.rels.to_h.to_json
      # fields = resource.fields.to_a.to_json
      Marshal.dump(resource.marshal_dump)
    end

    # @param [String] dumped data
    # @return [Sawyer::Resource] resource
    def self.marshal_load(dumped)
      resource = Sawyer::Resource.new(Octokit.agent)
      resource.marshal_load(Marshal.restore(dumped))
      resource
    end
  end
end
