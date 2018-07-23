require "rails_helper"

feature "User successfully sings in", %Q{
    As an unauthenticated user
    I want to sign in
    So that I can post my bookmarks
} do
  # acceptance_criterion:
  #   I must priovide valid email address and password for successful sign in.
  #   If I provide invalid email or password, I must be presented with errors

  scenario "successful sign in" do
    user = FactoryBot.create(:user)
    visit new_user_session_path

    # fill_in "First Name", with: user.first_name
    # fill_in "Last Name", with: user.last_name
    fill_in 'Email', with: user.email
    fill_in 'Password', with: user.password

    click_button 'Log in'

    expect(page).to have_content('Signed in successfully')
    expect(page).to have_content("Welcome #{user.first_name}!")
    expect(page).to have_content('Sign Out')
    page.has_css?('a.fi-plus', visible: true)
  end

  scenario 'specify invalid credentials' do
    visit new_user_session_path

    click_button 'Log in'
    expect(page).to have_content('Invalid Email or password')
    expect(page).to_not have_content('Sign Out')
    expect(page.has_no_css?('a.fi-plus')).to eq true
  end
end
