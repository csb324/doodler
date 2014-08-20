class DoodlesController < ApplicationController

  respond_to :json

  def index
  end

  def show
    @doodle = Doodle.find(params[:id])
  end

end
