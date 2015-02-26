class Api::StaticPagesController < ApplicationController
	def root
		render json: {}
	end
end