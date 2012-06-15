class Users::OmniauthCallbacksController < Devise::OmniauthCallbacksController

	def twitter
		@users = User.find_for_twitter_oauth(auth_hash)
		sign_in @user
		session["devise.uid"] = auth_hash["uid"]
		redirect_to home_path
	end

	def auth_hash
    request.env['omniauth.auth']
  end

end
