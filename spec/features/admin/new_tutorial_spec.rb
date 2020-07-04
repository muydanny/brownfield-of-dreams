require 'rails_helper'

feature "An admin can add a tutorial by importing from Youtube" do
  scenario "and it should redirect to /admin/dashboard" do
    admin = create(:admin)
    
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/tutorials/new"
    
    expect(page).to have_css('.import-youtube', count: 1)
    
    fill_in 'Title', with: 'Tutorial'
    fill_in 'Description', with: 'New Tutorial'
    fill_in 'Thumbnail', with: 'https://www.youtube.com/watch?v=4ABesTeDKmQ&list=PL01nNIgQ4uxNkDZNMON-TrzDVNIk3cOz4'
    
    click_link "Import Youtube Playlist"
    fill_in "tutorial_playlist_id",   with: "PL01nNIgQ4uxNkDZNMON-TrzDVNIk3cOz4" 
    click_on 'Save' 
    
    expect(current_path).to eq('/admin/dashboard')
    expect(page).to have_content('Successfully created tutorial. View it here.')
    
    click_link('View it here.')
    id = Tutorial.last.id
    expect(current_path).to eq("/tutorials/#{id}")

  end

  it "Can import a playlist with more than 50 videos" do
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/tutorials/new"
    
    fill_in 'Title', with: 'Tutorial'
    fill_in 'Description', with: 'New Tutorial'
    fill_in 'Thumbnail', with: 'https://www.youtube.com/watch?v=4ABesTeDKmQ&list=PL01nNIgQ4uxNkDZNMON-TrzDVNIk3cOz4'

    click_link "Import Youtube Playlist"
    fill_in "tutorial_playlist_id",   with: "PL01nNIgQ4uxNkDZNMON-TrzDVNIk3cOz4" 
    click_on 'Save' 

    click_link('View it here.')
    tutorial = Tutorial.last

    expect(tutorial.videos.count).to be > 50
  end
end

# As an admin
# When I visit '/admin/tutorials/new'
# Then I should see a link for 'Import YouTube Playlist'
# When I click 'Import YouTube Playlist'
# Then I should see a form

# And when I fill in 'Playlist ID' with a valid ID
# Then I should be on '/admin/dashboard'
# And I should see a flash message that says 'Successfully created tutorial. View it here.'
# And 'View it here' should be a link to '/tutorials/:id'
# And when I click on 'View it here'
# Then I should be on '/tutorials/:id'
# And I should see all videos from the YouTube playlist
# And the order should be the same as it was on YouTube