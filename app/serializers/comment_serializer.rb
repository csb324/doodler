class CommentSerializer < ActiveModel::Serializer
  attributes :id, :body, :points, :doodle_id, :user, :profile_picture_url
  has_one :user

  def profile_picture_url
    object.user.profile_picture_url
  end

end
