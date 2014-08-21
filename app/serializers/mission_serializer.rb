class MissionSerializer < ActiveModel::Serializer
  attributes :id, :name
  has_many :doodles
end
