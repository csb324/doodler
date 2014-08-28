class Highscore

  include ActiveModel::SerializerSupport

  def initialize(user)
    @user = user
  end

  def leaderboard(set_of_users)
    high_scores = []
    set_of_users.each do |user|
      person = {}
      person[:id] = user.id
      person[:profile_picture] = user.profile_picture
      person[:points] = user.points
      high_scores << object
    end
    high_scores
  end

  def global_leaderboard
    leaderboard(User.all)
  end

  def friends_leaderboard
    leaderboard(@user.friends)
  end

end
