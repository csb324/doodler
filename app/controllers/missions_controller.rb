class MissionsController < ApplicationController

  respond_to :json

  def index
    @missions = Mission.all
    respond_with(@missions)
  end

  def show
    @mission = Mission.find(params[:id])
  end

end
