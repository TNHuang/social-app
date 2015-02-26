json.posts @posts do |post|
	json.extract! post, :id, :title, :body, :updated_at, :created_at
end