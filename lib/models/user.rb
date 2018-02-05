require 'sequel'
require_relative 'repo'

module Models
  # User model
  class User < Sequel::Model
    plugin :serialization, :sawyer, :data
    many_to_many :repos
  end
end
