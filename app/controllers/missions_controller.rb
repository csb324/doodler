class MissionsController < ApplicationController

  respond_to :json, :html

  def default_serializer_options
    {root: false}
  end

  def index
    # these are the missions created in the last 24 hours! others are closed.
    @missions = Mission.where("created_at <= :now AND created_at >= :yesterday",
      {now: Time.now(), yesterday: Time.now() - 1.day })
  end

  def show
    @mission = Mission.find(params[:id])
    @doodles = @mission.doodles
    respond_with(@mission, @doodles)
  end

end
