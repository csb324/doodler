class MissionsController < ApplicationController

  respond_to :json, :html

  def index
    @missions = Mission.all
    respond_with(@missions)
  end

  def show
    @mission = Mission.find(params[:id])
    @doodles = @mission.doodles
    respond_with(@mission, @doodles)
  end

end
