class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :finish_signup, :first_sign_in]
  before_action :authenticate_user!, only: [:show]

  respond_to :html, :json

  def show
    @user
  end

  def first_sign_in
    @user
  end

  def finish_signup
    @user.update(user_params)
    if @user.save
      sign_in(@user)
      respond_with @user
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:nickname)
  end

end
