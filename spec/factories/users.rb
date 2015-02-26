FactoryGirl.define do
	factory :user, aliases: [:author, :left_friend, :right_friend] do
		first_name "John"
		last_name "Doe"
		email "abc@example.com"
		password "123456"
	end
end