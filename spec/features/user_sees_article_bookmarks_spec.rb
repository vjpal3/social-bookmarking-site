require "rails_helper"

feature "User sees bookmarked articles" do
  before(:each) do
    @user1 = FactoryBot.create(:user)
    @article1_1 = FactoryBot.create(:article)
    @articles_user1_1 = FactoryBot.create(:articles_user, user_id: @user1.id, article_id: @article1_1.id)
    @article1_2 = FactoryBot.create(:article)
    @articles_user1_2 = FactoryBot.create(:articles_user, user_id: @user1.id, article_id: @article1_2.id, access: 'private')

    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Sign in'
  end

  scenario "authorized user sees his/her own list of bookmarked articles" do
    # As an authorized user,
    # I would like to view my bookmarked list of articles, so that I can pick one to explore more.
    # Acceptance Criterion:
    # I must be signed in and should arrive here after clicking the link ‘Articles’.
    # I will be presented with the list of articles under the section ‘read’ with a brief info such as title, url, ‘bookmarked date’, rating, access(public/private), tags (if any) etc.
    # I should be able to switch to the ‘Todo List’ section.
    # I am also able to delete or edit the bookmarks I saved from this page.

    click_link 'My Article Bookmarks'
    expect(page).to have_content(@article1_1.title)
    expect(page).to have_link(href: @article1_1.url)
    expect(page).to have_content(@article1_1.tags)
    expect(page).to have_content(@article1_2.title)
    expect(page).to have_content(@article1_2.tags)
    # page.has_css?('span.fi-lock', visible: true)
  end

  scenario "authorized user doesn't have his/her own list of bookmarked articles yet" do
    click_link "Sign Out"
    user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Sign in'
    click_link 'My Article Bookmarks'
    expect(page).to have_content("You have not bookmarked any article yet!")
    expect(page).to_not have_content(@article1_1.title)
    expect(page).to_not have_content(@article1_2.title)
  end

  scenario "authorized user sees articles bookmarked by others available in public domain" do
    click_link "Sign Out"
    user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Sign in'
    click_link 'My Article Bookmarks'
    click_link 'Browse articles bookmarked by others'
    expect(page).to have_content("Articles bookmarked by other Users")
    expect(page).to have_content(@article1_1.title)
    expect(page).to_not have_content(@article1_2.title)
  end

  scenario "authorized user sees articles bookmarked by others available in public domain, excluding his/her own" do
    click_link "Sign Out"
    user3 = FactoryBot.create(:user)
    article3_1 = FactoryBot.create(:article)
    articles_user3_1 = FactoryBot.create(:articles_user, user_id: user3.id, article_id: article3_1.id)

    visit new_user_session_path
    fill_in 'Email', with: user3.email
    fill_in 'Password', with: user3.password
    click_button 'Sign in'
    click_link 'My Article Bookmarks'
    click_link 'Browse articles bookmarked by others'
    expect(page).to have_content("Articles bookmarked by other Users")
    expect(page).to have_content(@article1_1.title)
    expect(page).to_not have_content(article3_1.title)
  end

  scenario "un-authorized user sees all bookmarked articles available in public domain" do
    click_link "Sign Out"
    click_link 'Articles'
    expect(page).to have_content(@article1_1.title)
    expect(page).to_not have_content(@article1_2.title)
  end

  scenario "user sees bookmarks in public-domain by clicking tags" do
    click_link 'My Article Bookmarks'
    click_link @article1_1.tags
    expect(page).to have_content("Search Results for Tag: '#{@article1_1.tags}'")
    expect(page).to have_content(@article1_1.title)
  end
end
