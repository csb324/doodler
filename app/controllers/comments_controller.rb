class CommentsController < ApplicationController

  respond_to :json

  def default_serializer_options
    {root: false}
  end

  def index
  end

  def create
    @comment = Comment.new(body: params[:body])
    @doodle = Doodle.find(params[:doodle_id])
    @comment.doodle = @doodle

    @comment.user = current_user
    @comment.save

    respond_with @doodle, @comment
  end

  def destroy
  end

end
