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
    save_and_open_page
  end
end



# As a logged in user
# When I visit /dashboard
# Then I should see a section for "Github"
# And under that section I should see another section 
# titled "Following"
# And I should see list of users I follow with their 
# handles linking to their Github profile