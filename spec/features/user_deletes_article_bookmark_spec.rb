require "rails_helper"

feature "User deletes article bookmarks" , %Q{
  As an authorized user,
  I would like to delete an article-bookmark that I am no longer interested in.
  Acceptance Criterion:
  I must be signed in and should be able to click the button/link ‘Delete’, next to the item to be deleted.
  After successful deletion, I will be taken to the listing page, where I can no longer see that bookmark.
} do

  before(:each) do
    @user1 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Log in'

    @article1_1 = FactoryBot.create(:article)
    @articles_user1_1 = FactoryBot.create(:articles_user, user_id: @user1.id, article_id: @article1_1.id)

    @article1_2 = FactoryBot.create(:article)
    @articles_user1_2 = FactoryBot.create(:articles_user, user_id: @user1.id, article_id: @article1_2.id, access: 'private')
  end

  scenario "authorized user deletes bookmark from articles listing page" do
    click_link 'My Article Bookmarks'
    expect(page).to have_link('Delete')
    find_link('Delete', match: :first).click
    expect(page).to have_content("Bookmark was deleted successfully.")
    expect(page).to_not have_content(@article1_2.title)
  end

  scenario "authenticated user tries to delete other's bookmark" do
    click_link 'Sign Out'

    user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Log in'

    click_link 'My Article Bookmarks'
    click_link 'Browse articles bookmarked by other users'
    expect(page).to have_no_link('Delete')
  end

  scenario "un-authenticated user tries to delete bookmark" do
    click_link "Sign Out"
    click_link 'Articles'
    expect(page).to have_no_link('Delete')
  end

end
