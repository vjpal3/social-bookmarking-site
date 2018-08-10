require "rails_helper"

feature "User edits article bookmarks" , %Q{
  # As an authorized user,
  # I would like to edit the article-bookmark in my list so that I can keep my list updated.
  # Acceptance Criterion:
  # I must be signed in and should be able to click the button/link ‘Edit’, next to the item to be edited.
  # I will be presented with a form, prefilled with the data associated with that bookmark.
  # If I enter valid information, I will be taken to the listing page, where I can see the updated information.
  # If the form submission is unsuccessful, I will remain on the edit-form page, which lists the errors.
} do

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

  scenario "authorized user sees prefilled form fields" do
    click_link 'My Article Bookmarks'
    within ".bookmarks-data" do
      find_link('Edit', match: :first).click
    end
    expect(page).to have_content("Edit Article Bookmark")
    expect(page).to have_field("Title", with: @article1_2.title)
    expect(page).to have_field("Url", with: @article1_2.url)
    expect(page).to have_field("Tags", with: @article1_2.tags)
    expect(page).to have_checked_field('articles_user_access')
    expect(page).to have_unchecked_field('articles_user_status')
    expect(page).to have_checked_field("articles_user_user_rating_1")
    expect(page).to have_button("Update Bookmark")
  end

  scenario "authorized user successfully edits own bookmark" do
    article =  {
      title: "Includes vs Joins in Rails: When and where?",
      url: "http://tomdallimore.com/blog/includes-vs-joins-in-rails-when-and-where/",
      tags: "rails"
    }

    click_link('My Article Bookmarks')
    find_link('Edit', match: :first).click
    fill_in "Title", with: article[:title]
    fill_in "Url", with: article[:url]
    fill_in "Tags", with: article[:tags]
    check('articles_user_status')
    choose ('articles_user_user_rating_2')
    click_button("Update Bookmark")

    expect(page).to have_content("Bookmark was updated successfully.")
    expect(page).to have_content("Article Bookmark Details:")
    expect(page).to have_content(article[:title])
    expect(page).to have_selector(:css, 'a[href="http://tomdallimore.com/blog/includes-vs-joins-in-rails-when-and-where/"]')
    expect(page).to have_content(article[:tags])
    expect(page).to have_content('Access: private')
    expect(page).to have_content('Status: To-do')
    expect(page).to have_content("Rating: Loved it")
  end

  scenario 'authorized user fails to edit a bookmark' do
    click_link('My Article Bookmarks')
    find_link('Edit', match: :first).click
    fill_in "Title", with: ""
    fill_in "Url", with: ""
    fill_in "Tags", with: ""
    click_button("Update Bookmark")
    expect(page).to_not have_content("Bookmark was updated successfully.")
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Url can't be blank")
    expect(page).to have_field("Title", with: "")
    expect(page).to have_field("Url", with: "")
    expect(page).to have_field("Tags", with: "")
    expect(page).to have_checked_field('articles_user_access')
    expect(page).to have_unchecked_field('articles_user_status')
    expect(page).to have_checked_field("articles_user_user_rating_1")
    expect(page).to have_button("Update Bookmark")
  end

  scenario "authenticated user tries to edit other's bookmark" do
    click_link 'Sign Out'

    user2 = FactoryBot.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: user2.email
    fill_in 'Password', with: user2.password
    click_button 'Sign in'
    click_link('My Article Bookmarks')
    click_link 'Browse articles bookmarked by others'
    expect(page).to have_no_link('Edit')
  end

  scenario "un-authenticated user tries to edit bookmark" do
    click_link "Sign Out"
    click_link 'Articles'
    expect(page).to have_no_link('Edit')
  end

end
