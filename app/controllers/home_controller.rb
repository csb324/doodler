class HomeController < ApplicationController

  def index
    @missions = Mission.order(:created_at)
  end

end
