FactoryBot.define do
  factory :user do
    first_name 'Sally'
    last_name 'Morgan'
    sequence(:email) { |n| "member#{n}@example.com" }
    password 'password'
    password_confirmation 'password'
  end
end
