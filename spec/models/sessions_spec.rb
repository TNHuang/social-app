require 'rails_helper'

describe Session do 

	describe "#object instantiation and presistance" do
		it "can be instantiated" do
			expect(build(:session)).to be_an_instance_of(Session)
		end

		it "can be saved successfully" do
			expect(create(:session)).to be_persisted
		end
	end

	describe "#validations" do
		let(:missing_user_id) { build(:session, user_id: nil)}
		let(:missing_session_token) { build(:session, session_token: nil)}

		describe "#model level validations" do 
			it { should validate_presence_of(:session_token) }
			it { should validate_presence_of(:user_id) }

			it "validates pair uniqueness of session and user id" do
				s1 = create(:session)
				s2 = build(:session, session_token: s1.session_token)
				expect(s2).to_not be_valid
			end
		end

		describe "#should raise db error when validation is skipped" do 
			it "validates presence of user id" do
				expect{ missing_user_id.save!(validate: false) }.to raise_error
			end

			it "validates presensce of session" do 
				expect{ missing_session_token.save!(validate: false) }.to raise_error
			end

			it "validates pair uniqueness of session and user id" do
				s1 = create(:session)
				s2 = build(:session, session_token: s1.session_token)
				expect{ s2.save!(validate: false) }.to raise_error
			end
		end
	end

	describe "#associtation" do
		it { should belong_to(:user)}
	end	

	describe "#sign in" do 
		it "allow single sign in" do 
			create(:session)
			expect( Session.count ).to eq(1)
		end

		it "allow multiple sign in" do 
			sign_in1 = create(:session)
			sign_in2 = create(:session, session_token: "122")
			sign_in3 = create(:session, user_id: 2)
			expect(Session.where(:user_id => 1)).to eq([sign_in1, sign_in2]);
		end

		it "allow one session to sign out without sign out the other session" do
			sign_in1 = create(:session)
			sign_in2 = create(:session)
			sign_in2.destroy
			expect(sign_in1).to be_persisted
		end
		
	end

end
