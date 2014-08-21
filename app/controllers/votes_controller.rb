class VotesController < ApplicationController

  respond_to :json

  def update
    @vote = Vote.find_or_initialize_by(user: current_user, votable: votable)
    @vote.update(value: params[:value])
    @vote.save

    render json: @vote.votable
  end

  private

  def votable
    votable_id = params["#{params[:votable_type].underscore}_id"]
    params[:votable_type].constantize.find(votable_id)
  end

end
