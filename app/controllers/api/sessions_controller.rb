class Api::SessionsController < ApplicationController
	before_filter :api_require_signed_out, only: [:new, :create]
	before_filter :api_require_signed_in, only: [:destroy, :sign_out_all_sessions]

	def guest_sign_in
		@user = User.find_by(first_name: "Guest", last_name: "User")
		if @user
			sign_in!(@user)
			render template: "api/users/show"
		else
			@user = User.new(sessions_param)
			render json: { error: "Invalid name, email of password" }, status: :unprocessable_entity
		end
	end

	def create
		@user = User.find_by_credential(sessions_param)
		if @user
			sign_in!(@user)
			render template: "api/users/show"
		else
			@user = User.new(sessions_param)
			render json: { error: "Invalid name, email of password" }, status: :unprocessable_entity
		end
	end

	def destroy
		sign_out!
		render json: {}
	end

	#sign out all active session for current user
	def sign_out_all_sessions
		current_user.sessions.each {|s| s.destroy}
		session[:token] = nil
		render json: {}
	end

	private
	def sessions_param
		params.require(:user).permit(:first_name, :last_name, :email, :password)
	end

end