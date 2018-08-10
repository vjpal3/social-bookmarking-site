FactoryBot.define do
  factory :book do
    title "I Am Peace"
    isbn_13 "9781683351283"
    authors "Susan Verde"
    description "When the world feels chaotic, find peace within through an accessible mindfulness practice from the bestselling picture-book dream team that brought us I Am Yoga."
    publisher "Abrams"
    published_at 2017
    googlebooks_rating 4
    categories "Juvenile Fiction"
    thumbnail_url "http://books.google.com/books/content?id=H6xgDgAAQBAJ&printsec=frontcover&img=1&zoom=5&edge=curl&source=gbs_api"
    kid_friendly false
    approved false
    approved_by ""
  end
end
