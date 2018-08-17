require "rails_helper"

feature "User deletes book bookmarks" , %Q{
  As an authorized user,
  I would like to delete a book-bookmark that I am no longer interested in.
  Acceptance Criterion:
  I must be signed in and should be able to click the button/link ‘Delete’, next to the item to be deleted.
  After successful deletion, I will be taken to the listing page, where I can no longer see that bookmark.
} do

  before(:each) do
    @user1 = FactoryBot.create(:user)
    #Create these articles before 'Log in' process, otherwise, capybara wouldn't find these entries in the database
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    @books_user1 = FactoryBot.create(:books_user, user_id: @user1.id, book_id: @book1.id)

    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Sign in'
  end

  scenario "authorized user deletes bookmark from books listing page" do
    click_link('My Book Bookmarks')
    find_link('Delete Bookmark', match: :first).click
    # expect(page).to have_content("Bookmark was deleted successfully.")
    expect(page).to_not have_content(@book1.title)
  end

  scenario "authenticated user tries to delete other's bookmark" do
    click_link 'Sign Out'

    user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Sign in'
    click_link 'My Book Bookmarks'
    click_link 'Browse Books bookmarked by others'
    expect(page).to have_no_link('Delete Bookmark')
  end

  scenario "un-authenticated user tries to delete bookmark" do
    click_link "Sign Out"
    click_link 'Books'
    expect(page).to have_no_link('Delete Bookmark')
  end

end
