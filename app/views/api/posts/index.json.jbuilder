json.posts @posts do |post|
	json.extract! post, :id, :title, :body, :author_id, :updated_at, :created_at
end