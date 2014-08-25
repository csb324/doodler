class Mission < ActiveRecord::Base
  has_many :doodles
  belongs_to :user

  def open?
    if created_at <= Time.now() && created_at >= Time.now() - 1.day
      true
    else
      false
    end
  end

  def open_to_voting?
    if created_at <= Time.now() && created_at >= Time.now() - 2.days
      true
    else
      false
    end
  end

end
