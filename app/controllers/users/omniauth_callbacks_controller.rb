class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      sign @user
      render status: 200, json: { user: { email: @user.email }}
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]

      render status: 401, json: {errors: alert}
    end
  end

end
