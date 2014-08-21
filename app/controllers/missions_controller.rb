class MissionsController < ApplicationController

  respond_to :json, :html

  def default_serializer_options
    {root: false}
  end

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
