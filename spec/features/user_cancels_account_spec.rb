require "rails_helper"

feature "User cancels account", %Q{
  As an authenticated user
  I want to cancel my account
  beacuse I don't want to use this site anymore!
} do
  # Acceptance Criteria
    # * If I'm signed in, I have an option to sign out
    # * When I opt to sign out, I get a confirmation that my identity has been
    #   forgotten on the machine I'm using

  scenario "authenticated user cancels account successfully" do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password
    click_button 'Log in'

    find_link("Update Profile").click
    find_button("Cancel my account").click
    expect(page).to have_content("Bye! Your account has been successfully cancelled. We hope to see you again soon.")
    expect(page).to have_content("Sign Up")
    expect(page.has_no_css?('a.fi-plus')).to eq true
  end
end
