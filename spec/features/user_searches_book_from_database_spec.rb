require "rails_helper"

feature "User searches book from database", %Q{
  As an authorized user,
  I would like to search the books so that I can bookmark one that I want.
} do

  # Acceptance Criterion:
  # On the home page I can enter the keyword or book title.
  # I will be presented with the list of books available.
  # If I am signed in, I can bookmark the book, by default as 'read' or bookmark it as 'to-do'.
  # If I am not signed in, I will be prompted to sign in before saving the book.

  scenario "authorized user searches the book" do
    @user1 = FactoryBot.create(:user)
    @book1 = FactoryBot.create(:book)
    visit new_user_session_path
    fill_in 'Email', with: @user1.email
    fill_in 'Password', with: @user1.password
    click_button 'Sign in'

    click_link "Add Book"
    expect(page).to have_content('Search Book')
    within "#book-search-form" do
      find('#book_search')['Enter keyword (title, descrption, author)']
      fill_in('book_search', with: 'peace')
      find_button('Search Books').click
    end

    expect(page).to have_content('peace')
    expect(page).to have_button('Save')
    expect(page).to have_button('Save in To-dos')
  end

  scenario "un-authorized user searches the book" do
    @book1 = FactoryBot.create(:book)
    visit "/"
    click_link "Books"
    expect(page).to have_content('Search Book')
    within "#book-search-form" do
      find('#book_search')['Enter keyword (title, descrption, author)']
      fill_in('book_search', with: 'peace')
      find_button('Search Books').click
    end

    expect(page).to have_content('peace')
    expect(page).to have_button('Save')
    expect(page).to have_button('Save in To-dos')
  end
end
