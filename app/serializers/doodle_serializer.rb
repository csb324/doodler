class DoodleSerializer < ActiveModel::Serializer
  attributes :id, :user, :uploaded_image, :points, :doodleable_type, :doodleable_id
  has_one :user

  def uploaded_image
    object.image.url
  end

end
