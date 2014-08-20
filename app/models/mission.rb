class Mission < ActiveRecord::Base
  has_many :doodles
  belongs_to :user

end
