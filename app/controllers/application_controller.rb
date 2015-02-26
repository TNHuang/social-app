class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :current_user, :current_session, :signed_in?

  #scurrs
  def current_user
  	current_session ? current_session.user : nil
  end

  def current_session
  	return nil if !session[:token]
  	@current_session ||= Session.includes(:user).find_by_session_token(session[:token])
  end

  def signed_in?
  	!!current_session
  end

  private
  def sign_in!(user)
  	@current_user = user
  	session[:token] = user.sessions.create!.session_token
  end

  def sign_out!
  	current_session && current_session.destroy
  	session[:token] = nil
  end

  def require_signed_in
  	unless signed_in?
  		flash[:errors] = ["Require sign in to perform that action"]
  		redirect_to new_session_url
  	end
  end

  def require_signed_out
  	if signed_in?
  		flash[:errors] = ["Require sign out to perform that action"]
  		redirect_to user_url(current_user)
  	end
  end

  def api_require_signed_in
    unless signed_in?
      render json: { error: "action require user sign in" }, status: :unprocessable_entity
    end
  end

  def api_require_signed_out
    if signed_in?
      render json: { error: "action require sign out" }, status: :unprocessable_entity
    end
  end

  #this filter is use to prevent the page refresh to affect backbone view
  def refresh_filter
    if signed_in?
      sign_out!
      redirect_to "#"
    end
  end
end
