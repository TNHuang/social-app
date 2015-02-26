class PostsController < ApplicationController
	before_filter :require_current_user, only: [:create, :update, :destroy]

	def create
		@post = current_user.posts.new(post_params)
		unless @post.save
			flash.now[:errors] = @post.errors.full_messages
		end
		redirect_to user_url(current_user)
	end

	def update
		@post = Post.find(params[:id])
		unless @post.udpate(post_params)
			flash.now[:errors] = @post.errors.full_messages
		end
		redirect_to user_url(current_user)
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy
		redirect_to user_url()
	end


	private
	def post_params
		post_params = params.require(:post).permit(:title, :body)
		post_params.merge(author_id: params[:user_id])
	end

	def require_current_user
		if !signed_in? || User.find(params[:user_id]) != current_user
			render plain: "only signed in current user may peform this action", status: :forbidden
		end
	end
end
