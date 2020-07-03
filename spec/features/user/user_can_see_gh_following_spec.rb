require 'rails_helper'

describe 'Github followers' do

  before :each do
    @user = create(:user, token: ENV["GH_API_KEY"])
  end

  it "user can see a list of the profiles they follow from github" do
    visit '/'
    click_on "Sign In"
    expect(current_path).to eq(login_path)
    fill_in 'session[email]', with: @user.email
    fill_in 'session[password]', with: @user.password
    click_on 'Log In'
    
    within ".github_following" do
      expect(page).to have_content("Following")
    end
    
  end
end


