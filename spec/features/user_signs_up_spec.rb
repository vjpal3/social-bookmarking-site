require "rails_helper.rb"

feature 'user registers', %Q{
  As a prospective user
  I want to create an account
  So that I can post bookmarks
} do

  # Acceptance Criteria:
  # * I must specify a valid email address, first name, last name
  #   password, and password confirmation
  # * If I don't specify the required information, I am presented with
  #   an error message

  scenario 'provide valid registration information' do
    visit new_user_registration_path

    fill_in 'First Name', with: 'Sally'
    fill_in 'Last Name', with: 'Morgan'
    fill_in 'Email', with: 'sally@example.com'
    fill_in 'Password', with: 'password'
    fill_in 'Password confirmation', with: 'password'

    click_button 'Sign up'

    expect(page).to have_content('Welcome! You have signed up successfully.')
    expect(page).to have_content('Sign Out')
    page.has_css?('a.fi-plus', visible: true)
  end

  scenario 'Invalid registration information' do
    visit new_user_registration_path

    click_button 'Sign up'

    expect(page).to have_content('Email can\'t be blank')
    expect(page).to have_content('Password can\'t be blank')
    expect(page).to_not have_content('Sign Out')
    expect(page.has_no_css?('a.fi-plus')).to eq true
  end



end
