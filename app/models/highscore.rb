class Highscore

  include ActiveModel::SerializerSupport

  def initialize(user)
    @user = user
  end

  def leaderboard(set_of_users)
    high_scores = []
    set_of_users.each do |user|
      topscore = {}
      topscore[:user] = user
      topscore[:profile_picture] = user.profile_picture
      topscore[:points] = user.points
      high_scores << topscore
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
