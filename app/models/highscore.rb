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
      if user.profile_picture_url == "default.jpg"
        topscore[:profile_picture_url] = "/assets/default.jpg"
      else
        topscore[:profile_picture_url] = user.profile_picture_url
      end
      topscore[:points] = user.points
      high_scores << topscore
    end
    high_scores
  end

  def global_leaderboard
    leaderboard(User.all)
  end

  def friends_leaderboard
    me_and_friends = @user.friends + [@user]
    leaderboard(me_and_friends)
  end

end
