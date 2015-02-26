class UnorderValidator < ActiveModel::Validator
	def validate(friendship)
		if Friendship.find_by({ 
			left_friend_id: friendship.right_friend_id,
			right_friend_id: friendship.left_friend_id
			})
			friendship.errors[:left_friend_id] << "Friendship already existed in reverse order"
		end
	end
end

class Friendship < ActiveRecord::Base
	after_save :update_counter_cache
	after_update :update_counter_cache
	before_destroy :update_counter_cache_before_destroy
	
	#check to see if friend already exist in db but reverse order
	# friendship(john, jane) = friendship(jane, john)
	include ActiveModel::Validations
 	validates_with UnorderValidator
	
	validates :left_friend_id, :right_friend_id, presence: true
	validates :status, inclusion: { in: [1, 2]}
	validates_uniqueness_of :left_friend_id, scope: :right_friend_id

	belongs_to :left_friend,
	class_name: "User",
	foreign_key: :left_friend_id

	belongs_to :right_friend,
	class_name: "User",
	foreign_key: :right_friend_id

	belongs_to :pending_left_friend,
	class_name: "User",
	foreign_key: :left_friend_id

	belongs_to :pending_right_friend,
	class_name: "User",
	foreign_key: :right_friend_id


	#update the friends count whenever a friendship is destroy or update
	def update_counter_cache
		if status == 2 
			self.left_friend.reset_friends_count if self.left_friend
			self.right_friend.reset_friends_count if self.right_friend
		end
	end
	
	#remove the friends count before calling destroy
	def update_counter_cache_before_destroy
		if status == 2 
			self.left_friend.friends_count -= 1
			self.right_friend.friends_count -= 1
			self.left_friend.save
			self.right_friend.save
		end
	end	

end
