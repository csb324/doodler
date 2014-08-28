class HighscoreSerializer < ActiveModel::Serializer
  attributes :global_leaderboard, :friends_leaderboard
end
