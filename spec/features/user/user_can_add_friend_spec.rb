require 'rails_helper'

describe 'User' do
  before :each do
    @user = create(:user, token: ENV["GH_API_KEY"])
    @user_2 = create(:user, token: ENV["2_GH_API_KEY"], login: "jhgould")

    visit '/'
  
    click_on "Sign In"
  
    expect(current_path).to eq(login_path)
  
    fill_in 'session[email]', with: @user.email
    fill_in 'session[password]', with: @user.password
  
    click_on 'Log In'
  
    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content(@user.email)
    expect(page).to have_content(@user.first_name)
    expect(page).to have_content(@user.last_name)
  end

  it 'user sees links to add friend next to users in db' do
 
    within ".github_following" do
      expect(page).to have_content("5 Following")
      expect(page).to have_content('Add as Friend', count: 1)
    end
  end

  it 'adds friend to friend section on user dashboard' do 

    within ".github_following" do
      expect(page).to have_content("5 Following")
      click_on('Add as Friend')
    end
    
    expect(page).to have_content('Friend added!')
    expect(@user.friends.count).to eq 1 
  end
end