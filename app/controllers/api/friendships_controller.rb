class Api::FriendshipsController < ApplicationController
	before_filter :api_require_signed_in

	def search
		#find people who are not your friend
		friend_ids = current_user.friend_ids + [ current_user.id ]
		
		@new_friends = User.where([
				"id not in (?) and (first_name like ? or last_name like ?)",
				friend_ids, "%#{params[:query]}%", "%#{params[:query]}%"
				])
		render :query
	end

	def send_request
		@friendship = Friendship.find_by(
			left_friend_id: params[:user_id],
			right_friend_id: params[:right_friend_id]
			)
		if @friendship.nil?
			@friendship = Friendship.new(
			left_friend_id: params[:user_id],
			right_friend_id: params[:right_friend_id]
			)
			@friendship.save
		elsif @friendship.status == 1
			render json: { error: "Your request is already pending" }, status: :unprocessable_entity
		elsif @friendship.status == 2
			render json: { error: "You are already a friend with that person" }, status: :unprocessable_entity
		end

		render json: {message: "Friend request sent"}
	end

	def approve
		@friendship = Friendship.find_by(
			left_friend_id: params[:left_friend_id],
			right_friend_id: params[:user_id]
			)
		unless @friendship.update({status: 2})
			render json: { error: @friendship.errors.full_messages }, status: :unprocessable_entity
		end
		render json: {message: "Friendship approve"}
	end

	def destroy
		@friendship = Friendship.find_by(
			left_friend_id: params[:left_friend_id],
			right_friend_id: params[:user_id]
			)
		@friendship.destroy
		render json: {message: "Friendship deny"}
	end

	private
	def friendship_params
		params.require(:friendship).permit(:left_friend_id, :right_friend_id, :status)
	end
end