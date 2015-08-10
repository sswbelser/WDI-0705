RSpec.describe User, type: :model do

  before do
    user_params = Hash.new
    user_params[:first_name] = FFaker::Name.first_name
    user_params[:last_name] = FFaker::Name.last_name
    user_params[:email] = FFaker::Internet.email
    user_params[:password] = FFaker::Lorem.words(2).join
    user_params[:password_confirmation] = user_params[:password]
    @user = User.create(user_params)
  end

  describe "#email" do
    it "checks for an email" do
      expect(@user.email).not_to_be_empty
    end
  end

end