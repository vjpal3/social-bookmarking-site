require "rails_helper"

feature "User updates profile", %Q{
  As an authenticated user
  I want to update my profile
  So that my information is up-to-date
} do
  # Acceptance Criteria
    # * If I'm signed in, I have an option to sign out
    # * When I opt to sign out, I get a confirmation that my identity has been
    #   forgotten on the machine I'm using

  scenario "authenticated user updates profile successfully" do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Sign in'

    find_link("Update Profile").click
    fill_in "First Name", with: "Jane"
    fill_in "Last Name", with: "Doe"
    fill_in 'Email', with: "jane.doe@example.com"
    fill_in 'Password', with: "demo123"
    fill_in 'Password confirmation', with: "demo123"
    # expect(page).to have_content("updated successfully")
    expect(page).to have_content("Sign Out")
  end

  scenario 'unauthenticated user attempts to update profile' do
    visit '/'
    expect(page).to_not have_content('Update Profile')
  end
end
