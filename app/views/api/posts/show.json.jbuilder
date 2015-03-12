json.extract! @post, :id, :title, :body, :author_id, :updated_at, :created_at
json.author current_user.full_name
json.postAge Post.post_age(@post.created_at)
