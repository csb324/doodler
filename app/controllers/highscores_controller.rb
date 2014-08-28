class HighscoresController < ApplicationController

  respond_to :json

  def default_serializer_options
    {root: false}
  end

  def show
    @highscore = Highscore.new(User.find(params[:user_id]))
    respond_with @highscore
  end

end
