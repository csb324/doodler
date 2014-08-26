class HistoriesController < ApplicationController

  respond_to :json

  def default_serializer_options
    {root: false}
  end


  def show
    @history = History.new(User.find(params[:user_id]))
    respond_with @history
  end

end
