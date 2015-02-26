class Session < ActiveRecord::Base
	after_initialize :ensure_session_token

	validates :user_id, :session_token, presence: true
	validates :session_token, uniqueness: true

	belongs_to :user, inverse_of: :sessions

	def ==(other)
		other.is_a?(Session) && self.session_token == other.session_token
	end

	private

	def ensure_session_token
		self.session_token ||= generate_unique_session_token
	end

	def generate_unique_session_token
		begin
			token = SecureRandom.base64(16)
		end while Session.exists?(session_token: token)
		token
	end
end