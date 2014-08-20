class Doodle < ActiveRecord::Base
  belongs_to :mission
  belongs_to :user

  has_many :comments

end
