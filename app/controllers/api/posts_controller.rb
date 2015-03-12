class Api::PostsController < ApplicationController
	before_filter :require_current_user, only: [:create, :update, :destroy]

	def index
		@author = User.find(params[:user_id])
		@posts = @author.posts
		render :index
	end

	def show
		@post = Post.find(params[:id])
		render :show
	end

	def create
		@post = current_user.posts.new(post_params)
		unless @post.save
			render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
		end
		render :show
	end

	def update
		@post = Post.find(params[:id])
		unless @post.update(post_params)
			render json: { error: @post.errors.full_messages }, status: :unprocessable_entity
		end
		render :show
	end

	def destroy
		@post = Post.find(params[:id])
		@post.destroy
		render json: { message: "delete successful"} 
	end


	private
	def post_params
		post_params = params.require(:post).permit(:title, :body)
		post_params.merge(author_id: params[:user_id])
	end

	def require_current_user
		if !signed_in? || User.find(params[:user_id]) != current_user
			render json: { error: "only signed in current user may peform this action"}, status: :forbidden
		end
	end
end