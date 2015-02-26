class FriendshipsController < ApplicationController
	before_filter :require_signed_in

	def search
		#find people who are not your friend
		friend_ids = current_user.friend_ids + [ current_user.id ]
		@new_friends = User.where([
				"id not in (?) and (first_name like ? or last_name like ?)",
				friend_ids, "%#{params[:query]}%", "%#{params[:query]}%"
				])
		@friends = current_user.friends
		@pending_friends = current_user.pending_left_friends

		render :show
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
			flash[:errors] = ["Your request is arleady pending"]
		elsif @friendship.status == 2
			flash[:errors] = ["You are already friend with that person"]
		end

		redirect_to user_url(current_user)
	end

	def approve
		@friendship = Friendship.find_by(
			left_friend_id: params[:left_friend_id],
			right_friend_id: params[:user_id]
			)
		if !@friendship.update({status: 2})
			flash[:errors] = @friendship.errors.full_messages
		end
		redirect_to user_url(current_user)
	end

	def destroy
		@friendship = Friendship.find_by(
			left_friend_id: params[:left_friend_id],
			right_friend_id: params[:user_id]
			)
		@friendship.destroy
		redirect_to user_url(current_user)
	end

	private
	def friendship_params
		params.require(:friendship).permit(:left_friend_id, :right_friend_id, :status)
	end
end