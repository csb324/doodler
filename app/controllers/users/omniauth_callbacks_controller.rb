class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def facebook
    @user = User.from_omniauth(request.env["omniauth.auth"])

    if @user.persisted?
      if @user.sign_in_count == 0 || !@user.nickname
        puts "THIS IS A NEW USER OMG"
        redirect_to first_sign_in_path(@user)
      else
        sign_in_and_redirect @user
        set_flash_message(:notice, :success, :kind => "Facebook") if is_navigational_format?
      end
    else
      session["devise.facebook_data"] = request.env["omniauth.auth"]
      redirect_to new_user_registration_url
    end
  end

end
