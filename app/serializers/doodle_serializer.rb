class DoodleSerializer < ActiveModel::Serializer
  attributes :id, :user, :uploaded_image
  has_one :user

  def uploaded_image
    object.image.url
  end

end
