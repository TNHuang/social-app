json.friends @new_friends.each do | new_friend|
	json.partial! "api/shared/friend", {friend: new_friend}
end