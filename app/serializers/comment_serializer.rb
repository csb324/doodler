class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :points, :doodle_id, :user
  has_one :user

end
