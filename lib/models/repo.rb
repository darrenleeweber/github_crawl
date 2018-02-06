require 'sequel'
require_relative 'user'

module Models
  # Repo model
  class Repo < Sequel::Model
    plugin :serialization, :sawyer, :data
    many_to_many :users
  end
end
