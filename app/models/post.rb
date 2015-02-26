class Post < ActiveRecord::Base
	validates :author_id, :title, :body, presence:  true
	
	belongs_to :author,
	class_name: "User",
	foreign_key: :author_id,
	counter_cache: true

	def self.post_age(time_str)
		secs = Time.now.to_i - time_str.to_i
		if secs >= 31536000
			years = secs/3153600
			return "#{years} year#{'s' if years > 1}"
		elsif secs >= 2592000
			months = secs/259200
			return "#{months} month#{'s' if months > 1}"
		elsif secs >= 604800
			weeks = secs/604800
			return "#{weeks} week#{'s' if weeks > 1}"
		elsif secs >= 86400
			days = secs/86400
			return "#{days} day#{'s' if days > 1}"
		elsif secs >= 3600
			hours = secs/3600
			return "#{hours} hour#{'s' if hours > 1}"
		elsif secs >= 60
			minutes = secs/60
			return "#{minutes} minute#{'s' if minutes > 1}"
		else
			return "#{secs} seconds"
		end  
	end
end