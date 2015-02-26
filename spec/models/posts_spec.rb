require "rails_helper"

describe Post do
	describe "#object instantiation and presistance" do
		it "can be instantiated" do
			expect(build(:post)).to be_an_instance_of(Post)
		end

		it "can be saved successfully" do
			expect(create(:post)).to be_persisted
		end
	end

	describe "#validations" do
		let(:missing_author_id) { build(:post, author_id: nil)}
		let(:missing_title) { build(:session, title: nil)}
		let(:missing_body) { build(:post, body: nil)}

		describe "#model level validations" do 
			it { should validate_presence_of(:author_id)}
			it { should validate_presence_of(:title)}
			it { should validate_presence_of(:body)}
		end

		describe "#should raise db error when validation is skipped" do 
			it "validates presence of author id" do
				expect{ missing_author_id.save!(validate: false) }.to raise_error
			end

			it "validates presensce of title" do 
				expect{ missing_title.save!(validate: false) }.to raise_error
			end

			it "validates presence of body" do
				expect{ missing_body.save!(validate: false) }.to raise_error
			end
		end
	end

	describe "#assoications" do
		it { should belong_to(:author)}
	end
end
