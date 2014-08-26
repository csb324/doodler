class History

  def initialize(user)
    @user = user
    @dates = (@user.created_at.to_date .. Date.today)
  end




end
