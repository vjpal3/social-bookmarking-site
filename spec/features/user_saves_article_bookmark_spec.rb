require "rails_helper"

feature "User saves article bookmark available on the site in public domain", %Q{
  As a user,
  I would like to bookmark an article, available on the site so that I can view it later.
} do

  # Acceptance Criterion:
  # If I am signed in, I can see recently bookmarked articles on the home page.
  # I can also see available bookmarks by clciking ‘Browse articles bookmarked by others’
  # By default, the bookmark is listed as ‘read’. I can put it as ‘to-do'
  # If I am not signed in, I can see recently bookmarked articles on the home page.
  # I won't be able to save those bookmarks unless I am signed in.

  before(:each) do
    @user1 = FactoryBot.create(:user)
    @article1_1 = FactoryBot.create(:article)
    @articles_user1_1 = FactoryBot.create(:articles_user, user_id: @user1.id, article_id: @article1_1.id)

    visit new_user_session_path
    user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Sign in'
  end

  scenario "authorized user saves bookmark available on home page" do
    click_link "MyMarker!"
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_button("Save")
    expect(page).to have_button("Save in To-dos")
    find_button("Save").click
    expect(page).to have_content("Bookmark was successfully saved.")
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_content(@article1_1.tags)
  end

  scenario "authorized user saves bookmark available from other users" do
    click_link "My Article Bookmarks"
    click_link "Browse articles bookmarked by others"
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_button("Save")
    expect(page).to have_button("Save in To-dos")
    find_button("Save").click
    expect(page).to have_content("Bookmark was successfully saved.")
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_content(@article1_1.tags)
  end

  scenario "authorized user saves bookmark in To-dos" do

    click_link "MyMarker!"
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_button("Save")
    expect(page).to have_button("Save in To-dos")
    find_button("Save in To-dos").click
    expect(page).to have_content("Bookmark was successfully saved.")
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_content(@article1_1.tags)
    expect(page).to have_content("Status: To-do")
  end

  scenario "unauthorized user tries to save bookmark avalable on home page" do
    click_link 'Sign Out'
    # visit "/"
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_button("Save")
    expect(page).to have_button("Save in To-dos")
    find_button("Save").click
    expect(page).to have_content("Sign in required before proceeding.")
    expect(page).to have_content("Sign In")
    expect(page).to have_field('Email', with: '')
    expect(page).to have_field('Password', type: 'password')
  end

end
