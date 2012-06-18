class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

  def twitter
    @user = User.find_for_twitter_oauth(auth_hash)
    sign_in @user
    session["devise.uid"] = auth_hash["uid"]
		session["oauth_tokens"] = {
			:oauth_token => auth_hash["credentials"]["token"],
      :oauth_token_secret => auth_hash["credentials"]["secret"]
		}
    redirect_to home_path
  end

  def auth_hash
    request.env['omniauth.auth']
  end

end
