class Post < ActiveRecord::Base
	validates :author_id, :title, :body, presence:  true
	
	belongs_to :author,
	class_name: "User",
	foreign_key: :author_id,
	counter_cache: true
end