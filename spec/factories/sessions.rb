FactoryGirl.define do
	factory :session do
		user_id 1
		session_token { SecureRandom.base64(16) }
	end
end
