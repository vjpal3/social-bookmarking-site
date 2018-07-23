require "rails_helper"

feature "User signs out successfully", %Q{
  As an authenticated user
  I want to sign out
  So that no one else can post bookmarks on my behalf
} do
  # Acceptance Criteria
    # * If I'm signed in, I have an option to sign out
    # * When I opt to sign out, I get a confirmation that my identity has been
    #   forgotten on the machine I'm using

  scenario "authenticated user signs out" do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    expect(page).to have_content('Signed in successfully')

    find_link("Sign Out").click
    expect(page).to have_content("Signed out successfully")
    expect(page).to have_content("Sign In")
    expect(page.has_no_css?('a.fi-plus')).to eq true
  end

  scenario 'unauthenticated user attempts to signs out' do
    visit '/'
    expect(page).to_not have_content('Sign Out')
  end
end
