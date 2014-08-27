class MissionsController < ApplicationController

  respond_to :json, :html

  def default_serializer_options
    {root: false}
  end

  def index
    # these are the missions created in the last 24 hours! others are closed.
    @open_missions = Mission.where("created_at BETWEEN :yesterday AND :now",
      { now: Time.now(), yesterday: Time.now() - 1.day })

    @votable_missions = Mission.where("created_at BETWEEN :day_before AND :yesterday",
      { yesterday: Time.now() - 1.day, day_before: Time.now() - 2.days })

    # what is this doing here??
    @recent_doodles = Doodle.order(created_at: :desc).limit(6)

  end

  def show
    @mission = Mission.find(params[:id])
    @doodles = @mission.doodles
    respond_with(@mission, @doodles)
  end

end
