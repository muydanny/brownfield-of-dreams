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

  it "Can import a playlist with 200 plus videos - edge case " do 
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/tutorials/new"

    fill_in 'Title', with: 'Tutorial'
    fill_in 'Description', with: 'New Tutorial'
    fill_in 'Thumbnail', with: 'https://www.youtube.com/watch?v=-qv7k2_lc0M&list=PL83DDC2327BEB616D'
  
    click_link "Import Youtube Playlist"
    fill_in "tutorial_playlist_id",   with: "PL83DDC2327BEB616D" 
    click_on 'Save' 

    click_link('View it here.')
    tutorial = Tutorial.last

    expect(tutorial.videos.count).to be > 200
  end
  it "Can save a video without playlist id and goes to tutorial id page" do 
    admin = create(:admin)
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(admin)

    visit "/admin/tutorials/new"

    fill_in 'Title', with: 'Tutorial'
    fill_in 'Description', with: 'New Tutorial'
    fill_in 'Thumbnail', with: 'https://www.youtube.com/watch?v=-qv7k2_lc0M&list=PL83DDC2327BEB616D'
  
    
    click_on 'Save' 

    tutorial = Tutorial.last
    expect(current_path).to eq("/tutorials/#{tutorial.id}")

    expect(page).to have_content('Successfully created tutorial.')
  end
end

# When I visit '/admin/tutorials/new'
# And I fill in 'title' with a meaningful name
# And I fill in 'description' with a some content
# And I fill in 'thumbnail' with a valid YouTube thumbnail
# And I click on 'Save'
# Then I should be on '/tutorials/{NEW_TUTORIAL_ID}'
# And I should see a flash message that says "Successfully created tutorial."