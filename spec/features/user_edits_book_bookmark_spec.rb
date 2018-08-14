 require "rails_helper"

feature "User edits book bookmark", %Q{
  As an authorized user,
  I would like to edit book's status so that I can keep track of the books as 'read' or 'to-do'.
  I would like to edit book's user rating so that others can have an idea about the book.
} do

  # Acceptance Criterion:
  #I must be signed in.
  #On the page of my books listing, I should be able to change the status and user rating of any individual book.

  scenario "authorized user changes status of the book" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    @books_user1 = FactoryBot.create(:books_user, user_id: @user1.id, book_id: @book1.id)
    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Sign in'

    click_link 'My Book Bookmarks'
    expect(page).to have_content('Peace')
    expect(page).to have_content('Status: read')
    find_button('Change Status').click
    choose 'To-do'
    find('input[name="change_status"]').click
    expect(page).to have_content('Status: To-do')
  end

  scenario "un-authorized user tries to change status of the book" do
    visit '/'
    click_link 'Books'
    expect(page).to_not have_button('Change Status')
  end

  scenario "authorized user tries to change status of the others' bookmarks" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    @books_user1 = FactoryBot.create(:books_user, user_id: @user1.id, book_id: @book1.id)
    @user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: @user2.email
    fill_in 'Password', with: @user2.password
    click_button 'Sign in'

    click_link 'My Book Bookmarks'
    click_link 'Browse Books bookmarked by others'
    expect(page).to have_content('Peace')
    expect(page).to_not have_button('Change Status')
  end

  scenario "authorized user changes user-rating of the book" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    @books_user1 = FactoryBot.create(:books_user, user_id: @user1.id, book_id: @book1.id)
    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Sign in'

    click_link 'My Book Bookmarks'
    expect(page).to have_content('Peace')
    expect(page).to have_content('User Rating: Liked it')
    find_button('Change User Rating').click
    choose 'Loved it'
    find('input[name="change_rating"]').click
    expect(page).to have_content('User Rating: Loved it')
  end

  scenario "authorized user tries to change user-rating of others' bookmark" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    @books_user1 = FactoryBot.create(:books_user, user_id: @user1.id, book_id: @book1.id)
    @user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: @user2.email
    fill_in 'Password', with: @user2.password
    click_button 'Sign in'
    click_link 'My Book Bookmarks'
    click_link 'Browse Books bookmarked by others'
    expect(page).to have_content('Peace')
    expect(page).to_not have_button('Change User Rating')
  end

  scenario "un-authorized user tries to change user rating of the book" do
    visit '/'
    click_link 'Books'
    expect(page).to_not have_button('Change User Rating')
  end
end
