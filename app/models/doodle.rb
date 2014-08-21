class Doodle < ActiveRecord::Base
  include Votable
  belongs_to :mission
  belongs_to :user

  has_many :comments

  mount_uploader :image, DoodlefileUploader

end
