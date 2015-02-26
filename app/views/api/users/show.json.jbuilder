json.extract! @user, :id, :friends_count, :posts_count, :created_at, :updated_at
json.name @user.full_name
json.isCurrentUser @is_current_user
if @is_current_user
	json.session_id current_session.id
end

json.friends @friends do |friend|
	json.partial! 'api/shared/friend', {friend: friend}
end

json.pendingFriends @pending_friends do |pending_friend|
	json.partial! 'api/shared/friend', { friend: pending_friend }
end

json.allPosts @all_posts do |post|
	json.id post[:post].id
	json.title post[:post].title
	json.body post[:post].body
	json.author post[:author]
	json.authorId post[:author_id]
	json.postAge post[:post_age]
end
