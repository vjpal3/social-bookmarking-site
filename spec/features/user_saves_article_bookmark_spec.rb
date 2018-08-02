require "rails_helper"

feature "User adds a bookmarked article", %Q{
  As an authorized user,
  I would like to bookmark an article so that I can view it later.
  I would choose the bookmark to be either public or private depending on the content.
} do

  # Acceptance Criterion:
  # I must be signed in and should arrive here after clicking ‘(+)’ next to ‘Article’ link.
  # I must provide the Title & URL of the article.
  # By default, the bookmark is public. I should be able to mark it as private, if I want to.
  # By default, the bookmark is listed as ‘read’. I can put it as ‘Todo List’
  # I can optionally add a tag or select one from the select box.
  # If I do not provide a title, proper URL or no Url, I will be presented with errors,
  # and I should remain on the new bookmark page.
  # The form should be pre-filled with the values that were provided when the form was submitted.

  before(:each) do
    @user = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: @user.email
    fill_in 'Password', with: @user.password
    click_button 'Log in'
  end

  scenario "authorized user successfully saves article bookmark" do
    click_link "Add Article"
    expect(page).to have_content('Add Article Bookmark')
    fill_in "Title", with: "Ruby on Rails - Framework"
    fill_in "Url", with: "https://www.tutorialspoint.com/ruby-on-rails/rails-framework.htm"
    check('Private')
    check('To-do')
    choose 'Loved it'
    fill_in "Tags", with: "ruby rails"
    find_button("Save Bookmark").click
    expect(page).to have_content("Bookmark was successfully saved.")
    expect(page).to have_content("Ruby on Rails - Framework")
    expect(page).to have_content("tutorialspoint.com")
    expect(page).to have_content("ruby rails")
    expect(page).to have_selector(:css, 'a[href="https://www.tutorialspoint.com/ruby-on-rails/rails-framework.htm"]')
  end

  scenario "authorized user fails to save article bookmark" do
    click_link "Add Article"
    find_button("Save Bookmark").click
    expect(page).to_not have_content("Bookmark was successfully saved.")
    expect(page).to have_content("Url can't be blank")
    expect(page).to have_content("Title can't be blank")
  end

  scenario "unauthorized user attempts to save article bookmark" do
    click_link "Sign Out"
    expect(page.has_no_css?('a.fi-plus')).to eq true
    expect(page).to_not have_link("Add Article")
  end


end
