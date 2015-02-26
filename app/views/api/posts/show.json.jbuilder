json.extract! @post, :id, :title, :body, :author_id, :updated_at, :created_at
json.author current_user.full_name
json.postAge current_user.post_age(@post.created_at)