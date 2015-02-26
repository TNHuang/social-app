class SessionsController < ApplicationController
	before_filter :require_signed_out, only: [:new, :create]
	before_filter :require_signed_in, only: [:destroy, :sign_out_all_sessions]

	def new
		@user = User.new()
		render :new
	end

	def create
		@user = User.find_by_credential(sessions_param)
		if @user
			sign_in!(@user)
			redirect_to user_url(@user)
		else
			flash[:errors] = ["Invalid name, email or password"]
			@user = User.new(sessions_param)
			render :new
		end
	end

	def destroy
		sign_out!
		redirect_to root_url
	end

	#sign out all active session for current user
	def sign_out_all_sessions
		current_user.sessions.each {|s| s.destroy}
		session[:token] = nil
	end

	private
	def sessions_param
		params.require(:user).permit(:first_name, :last_name, :email, :password)
	end

end
