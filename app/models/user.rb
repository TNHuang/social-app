class EmailValidator < ActiveModel::EachValidator
	def validate_each(record, attribute, value)
		unless value =~ /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/
			record.errors[attribute] << ( options[:message] || "is invalid email")
		end
	end
end

class User < ActiveRecord::Base
	attr_reader :password

	validates :first_name, :last_name, :password_digest, presence: true
	validates :email, presence: true, email: true
	validates :email, :password_digest, uniqueness: true

	validates :password, length: { minimum: 6, allow: nil},
			  :if => :password_digest_changed? 
			  #only validate if password_digest change

	validates_uniqueness_of :email, scope: [:first_name, :last_name]

	has_many :sessions,	inverse_of: :user, dependent: :destroy

	has_many :posts,
	class_name: "Post",
	foreign_key: :author_id, 
	dependent: :destroy

	has_many :left_friendships,
	class_name: "Friendship",
	foreign_key: :right_friend_id,
	dependent: :destroy

	has_many :right_friendships,
	class_name: "Friendship",
	foreign_key: :left_friend_id,
	dependent: :destroy

	#left friends are friends who made friend requests to you
	has_many :left_friends, 
	-> {where friendships: { status: 2}},
	through: :left_friendships

	#rght friends are friends whom you made request to
	has_many :right_friends,
	-> {where friendships: { status: 2}},
	through: :right_friendships

	#pending friendship request, not yet approve
	#user can approve/deny pending left friends
	has_many :pending_left_friends,
	-> {where friendships: {status: 1}},
	through: :left_friendships

	#pending right friends are friends you sent request to, but yet to approve you
	has_many :pending_right_friends,
	-> {where friendships: {status: 1}},
	through: :right_friendships

	has_many :left_friends_posts, 
	through: :left_friends, 
	source: :posts

	has_many :right_friends_posts, 
	through: :right_friends, 
	source: :posts

	def full_name
		self.first_name + " " + self.last_name
	end

	def friends
		left_friends + right_friends
	end

	def friend_ids
		#return all friends_id,
		#use to filter out pre-existing friend in new friend search
		self.left_friendships.map {|f| f.left_friend_id} +
		self.right_friendships.map {|f| f.right_friend_id}
	end

	def reset_friends_count
		#count all valid friend
		friends_count = Friendship.where(
			["(left_friend_id = ? or right_friend_id = ?) and status = ?",
			self.id, self.id, 2]
			).count
		self.update({friends_count: friends_count})
	end

	#return all posts authored by current user or user's friend
	def all_posts
		#eager load author to avoid N+1 query
		my_posts = extract_post_info( posts.includes(:author) )
		left_posts = extract_post_info( left_friends_posts.includes(:author) )
		right_posts = extract_post_info( right_friends_posts.includes(:author) )

		result = my_posts + left_posts + right_posts
		#sort by udpated_at, so the most recent post is at top
		result.sort_by {|post| post[:post].updated_at }.reverse[0..9]
	end 
 	
 	def extract_post_info(posts)
 		result = posts.map do |post|
			{ 
			:post => post,
			:author => post.author.first_name + " " + post.author.last_name,
			:author_id => post.author_id,
			:post_age => Post.post_age(post.created_at),
			}
		end
		result
	end

	def ==(other)
 		other.is_a?(User) && self.id == other.id
 	end

	def self.find_by_credential(params)
		user = User.find_by(
			first_name: params[:first_name],
			last_name: params[:last_name],
			email: params[:email]
			)
		return user if user && user.is_password?(params[:password]);
		nil
	end

	def password=(password)
		@password = password
		self.password_digest = BCrypt::Password.create(password)
	end

	def is_password?(password)
		BCrypt::Password.new(self.password_digest).is_password?(password)
	end

end
