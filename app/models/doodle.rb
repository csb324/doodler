class Doodle < ActiveRecord::Base
  belongs_to :mission
  belongs_to :user

  has_many :comments

  mount_uploader :image_path, DoodlefileUploader

end
