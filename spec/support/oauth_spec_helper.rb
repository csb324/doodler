module OauthSpecHelper
  def login_with_oauth(service = :facebook)
    visit "users/auth/#{service}"
  end
end
