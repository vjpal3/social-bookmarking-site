FactoryBot.define do
  factory :articles_user do
    user_id ""
    article_id ""
    user_rating 1
    access "public"
    status "read"

    user
    article
  end
end
