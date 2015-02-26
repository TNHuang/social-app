# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

10.times do 
	@user = User.create({
			first_name: Faker::Name.first_name,
			last_name: Faker::Name.last_name,
			email: Faker::Internet.email,
			password: "123456"
			});
	(rand(3)+1).times do 
		@user.posts.create({
		title: Faker::Hacker.say_something_smart,
		body: Faker::Hacker.say_something_smart
		})
	end
end

User.create({ first_name: "Guest", last_name: "User", email: "guest@user.com", password: "123456"});


user_ids = User.all.map {|u| u.id}
friendship_count = 30

left_friend_id = user_ids.sample
right_friend_id = user_ids.sample

until friendship_count == 0
	left_friend_id = user_ids.sample
	right_friend_id = user_ids.sample while left_friend_id == right_friend_id

	if Friendship.find_by(
		left_friend_id: left_friend_id,
		right_friend_id: right_friend_id) ||
		Friendship.find_by(
		left_friend_id: right_friend_id,
		right_friend_id: left_friend_id)
		next
	end
	Friendship.create({
		left_friend_id: left_friend_id,
		right_friend_id: right_friend_id,
		status: (rand(2)+1)
		})
	friendship_count -= 1
end
