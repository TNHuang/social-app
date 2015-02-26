json.users @users.each do |user|
	json.extract! user, :id, :first_name, :last_name, :friends_count, :posts_count
	json.name user.full_name
end