require "rails_helper"

describe User do
	describe '#object' do
		it "can be instantiated" do
			expect(build(:user)).to be_an_instance_of(User)
		end
		it "can be save successfully" do
			expect(create(:user)).to be_persisted
		end
	end

	describe "#validations" do
		let(:missing_email) { build(:user, email: nil)}
		let(:missing_first_name) { create(:user, first_name: nil)}
		let(:missing_last_name) { create(:user, last_name: nil)}
		let(:missing_both_name) { create(:user, first_name: nil, last_name: nil)}

		describe "#model level" do
			it { should validate_presence_of(:first_name)}
			it { should validate_presence_of(:last_name)}
			it { should validate_presence_of(:email)}

			it "validate pair uniqueness of username and email" do
				user = create(:user)
				copy_user = build(:user)
				expect(copy_user).to_not be_valid
			end

			describe "password" do
				it "should not be null" do
					user = build(:user, password: nil)
					expect(user).to_not be_valid
				end
				it "should not be empty" do
					user = build(:user, password: "")
					expect(user).to_not be_valid
				end
				it "should be longer than 6 characters" do 
					user = build(:user, password: "123")
					expect(user).to_not be_valid
				end
				it "should be valid if password >= 6 chars" do
					user = build(:user, password: "123456abc")
					expect(user).to be_valid
				end
			end

			describe "email validations" do
				let(:missing_local)       { build(:user, email: "@example.com") }
				let(:missing_at_sign)     { build(:user, email: "abcexample.com") }
				let(:missing_domain_name) { build(:user, email: "abc@") }
				let(:correct_email)       { build(:user, email: "abc@example.com") }

				it "missing local part: '@example.com' should be invalid" do
					expect(missing_local).to_not be_valid
				end

				it "missing symbol part: 'abcexample.com' should be invalid" do
					expect(missing_at_sign).to_not be_valid
				end

				it "missing domain name: 'abc@' should be invalid" do
					expect(missing_domain_name).to_not be_valid
				end

				it "abc@exmaple.com should be valid" do
					expect(correct_email).to be_valid
				end
			end
		end

		describe "#should raise db error when model validations are skipped" do
			it "validates the presence of first_name" do
				expect{ missing_first_name.save!(validate: false) }.to raise_error
			end
			it "validates presence of last_name" do
				expect{ missing_last_name.save!(validate: false) }.to raise_error
			end
			it "validate presence of both first and last name" do
				expect{ missing_both_name.save!(validate: false) }.to raise_error
			end
			it "validate the presence of email" do
				expect{ missing_email.save!(validate: false) }.to raise_error
			end
		end
	end

	describe "#associtations" do
		it {should have_many(:sessions)}
		it {should have_many(:posts)}

		it {should have_many(:left_friendships)}
		it {should have_many(:right_friendships)}

		it {should have_many(:left_friends)}
		it {should have_many(:right_friends)}

		it {should have_many(:pending_left_friends)}
		it {should have_many(:pending_right_friends)}

		it {should have_many(:left_friends_posts)}
		it {should have_many(:right_friends_posts)}
	end
end