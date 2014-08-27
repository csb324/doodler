class Mission < ActiveRecord::Base
  has_many :doodles, as: :doodleable
  belongs_to :user
  belongs_to :winner, class_name: "Doodle"

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
      set_winner unless winner_set?
      false
    end
  end

  def winner_set?
    if winner == nil
      false
    else
      true
    end
  end

  def set_winner
    self.winner = doodles.sort_by { |doodle| doodle.points }.reverse.first
  end

end
