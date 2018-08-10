FactoryBot.define do
  factory :books_user do
    user_id ""
    book_id ""
    user_rating 1
    access "public"
    status "read"

    user
    book
  end
end
