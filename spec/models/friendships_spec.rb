require "rails_helper"

describe Friendship do
	describe "#object instantiation and presistance" do
		it "can be instantiated" do
			expect(build(:friendship)).to be_an_instance_of(Friendship)
		end

		it "can be saved successfully" do
			expect(create(:friendship)).to be_persisted
		end
	end

	describe "#validations" do
		let(:missing_left_friend_id) { build(:friendship, left_friend_id: nil)}
		let(:missing_right_friend_id) { build(:friendship, right_friend_id: nil)}

		describe "#model level validations" do 
			it { should validate_presence_of(:left_friend_id) }
			it { should validate_presence_of(:right_friend_id) }
			it { should validate_inclusion_of(:status).in_array([1, 2]) }

			it "validates pair uniqueness of session and user id" do
				s1 = create(:session)
				s2 = build(:session, session_token: s1.session_token)
				expect(s2).to_not be_valid
			end
		end

		describe "#should raise db error when validation is skipped" do 
			it "validates presence of left_friend_id" do
				expect{ missing_left_friend_id.save!(validate: false) }.to raise_error
			end

			it "validates presensce of right_friend_id" do 
				expect{ missing_right_friend_id.save!(validate: false) }.to raise_error
			end

		end
	end

	describe "#associtations" do
		it {should belong_to(:left_friend)}
		it {should belong_to(:right_friend)}
		it {should belong_to(:pending_left_friend)}
		it {should belong_to(:pending_right_friend)}
	end
end