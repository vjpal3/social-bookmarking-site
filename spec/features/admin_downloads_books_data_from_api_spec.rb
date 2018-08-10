require "rails_helper"

feature "Admin downloads books data from API", %Q{
  As an Admin,
  I would like to download books data from Google-books API,
  so that memebres of the site can bookmark the books they like.
} do
  # Acceptance Criterion:
  # I must be signed in as a role of admin.
  # In the admin section of the site, I can enter the keyword to download books data.
  # I must see the listing of new books that have been downloaded.
  # I should not see the books that are already in the database.

  scenario "Admin successfully downloads books data from API" do
    @user = FactoryBot.create(:user, role: "admin")
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
    expect(page).to have_content("Welcome to Admin Section")
    within "#api-search-form" do
      find('#api_search')['Enter keyword to download books']
      fill_in('api_search', with: "space")
      click_button "Search API and Download Books Data"
    end
    expect(page).to have_content("Following Search Results were successfully saved to the database:")
    expect(page).to have_content("space")
  end

  scenario "unauthenticated user tries to download books data from API" do
    visit "/"
    expect(page).to_not have_button("Search API and Download Books Data")
  end

  scenario "A memeber who is not admin, tries to download books data from API" do
    @user = FactoryBot.create(:user, role: "member")
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Sign in'
    expect(page).to_not have_button("Search API and Download Books Data")
  end

end
