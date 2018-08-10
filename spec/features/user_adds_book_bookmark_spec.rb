require "rails_helper"

feature "User adds book bookmark", %Q{
  As an authorized user,
  I would like to bookmark a book so that I can view it later.
  I would choose the bookmark to be either 'read' or 'To-do' depending on the content.
} do

  # Acceptance Criterion:
  #I must be signed in and should arrive here after clicking ‘(+)’ next to ‘Book’ link.
  #By default, the bookmark is listed as ‘read’. I can put it as ‘Todo List

  scenario "authorized user adds the book after searching the database" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Sign in'

    click_link "Add Book"
    within "#book-search-form" do
      fill_in 'book_search', with: 'peace'
      click_button('Search Books')
    end

    click_button('Save')
    expect(page).to have_content('Peace')
    expect(page).to have_content('Status: read')
    expect(page).to have_button('Change Status')
  end

  scenario "authorized user adds the book from available bookmarks on the site" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    @books_user1 = FactoryBot.create(:books_user, user_id: @user1.id, book_id: @book1.id)

    @user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: @user2.email
    fill_in 'Password', with: @user2.password
    click_button 'Sign in'

    click_link "My Book Bookmarks"
    click_link "Browse Books bookmarked by others"
    expect(page).to have_content('Peace')
    # save_and_open_page
    find_button('Save').click
    expect(page).to have_content('peace')
    expect(page).to have_content('Status: read')
    find("img[src^='http://books.google.com']")
    end

  scenario "un-authorized user tries to add the book after searching the database" do
    @book1 = FactoryBot.create(:book)
    visit "/"
    click_link "Book"
    within "#book-search-form" do
      fill_in 'book_search', with: 'peace'
      click_button('Search Books')
    end

    expect(page).to have_content('peace')
    find("img[src^='http://books.google.com']")
    
    click_button('Save')
    expect(page).to have_content("Sign in required before proceeding.")
    expect(page).to have_content("Sign In")
    expect(page).to have_field('Email', with: '')
    expect(page).to have_field('Password', type: 'password')
  end


end
