class VotesController < ApplicationController

  respond_to :json

  def update
    @vote = Vote.find_or_initialize_by(user: current_user, votable: votable)

    # if the person has already upvoted (for example) this thing, take it back
    if @vote.value == params[:value].to_i
      @vote.update(value: 0)
    else
      # if they haven't already done the thing they're trying to do, do the thing
      @vote.update(value: params[:value])
    end
    @vote.save

    # respond_with doesn't work here, because PUT requests return nothing
    render json: @vote.votable
  end

  private

  def votable
    votable_id = params["#{params[:votable_type].underscore}_id"]
    params[:votable_type].constantize.find(votable_id)
  end

end
