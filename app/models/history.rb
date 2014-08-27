class History

  include ActiveModel::SerializerSupport

  def initialize(user)
    @user = user
    @dates = (@user.created_at.to_date .. Date.today)
  end

  def doodle_points(day)
    points = 0
    @user.doodles.each do |doodle|
      # the values in "dates" are at MIDNIGHT
      # so I'll test to see if the timestamp is between date and (date + 1 day)
      # that's the duration of the whole day
      # (until next day at midnight)
      if doodle.votes.present? # this saves time
        days_votes = doodle.votes.where(
          "created_at BETWEEN :day_start AND :day_end",
          { day_start: day, day_end: day + 1.day })
      end

      if days_votes.present?
        points += days_votes.map(&:value).reduce(&:+)
      end
    end
    points
  end

  def doodle_points_so_far(day)
    date_range = (@user.created_at.to_date .. day)
    points = 0
    date_range.each do |singleday|
      points += doodle_points(singleday)
    end
    points
  end

  def doodle_count(day)
    @user.doodles.where(
      "created_at BETWEEN :day_start AND :day_end",
      { day_start: day, day_end: day + 1.day }).size
  end

  def history
    days = []
    @dates.each do |day|
      this_day = {}
      this_day[:day] = day
      this_day[:points_per_day] = doodle_points(day)
      this_day[:points_so_far] = doodle_points_so_far(day)
      this_day[:doodles_per_day] = doodle_count(day)
      days << this_day
    end
    days
  end

end


