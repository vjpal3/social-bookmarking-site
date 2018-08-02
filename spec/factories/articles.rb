FactoryBot.define do
  factory :article do
    sequence(:title) { |n| "A good collection of Ruby Tutorials#{n}" }
    sequence(:url) { |n| "https://rubymonk.com/#{n}" }
    host "rubymonk.com"
    avg_rating ""
    sequence(:tags) { |n| "ruby#{n}" }
    kid_friendly false
    approved false
    shared_by ""
    approved_by ""
  end
end
