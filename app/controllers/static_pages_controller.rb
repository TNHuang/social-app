class StaticPagesController < ApplicationController
	# before_filter :refresh_filter
	def root
		render :root
	end
end