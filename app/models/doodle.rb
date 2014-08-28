class Doodle < ActiveRecord::Base
  include Votable
  belongs_to :doodleable, polymorphic: true
  belongs_to :user

  has_many :comments, dependent: :destroy

  mount_uploader :image, DoodlefileUploader

end
