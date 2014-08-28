module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def voted_by?(user, value)
    votes.find_by(user_id: user.id, value: value).present?
  end

  def points
    if votes.present?
      votes.map(&:value).reduce(&:+)
    else
      0
    end
  end

end
