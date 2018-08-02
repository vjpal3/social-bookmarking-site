class ArticlesUser < ApplicationRecord
  RATINGS = [
    [1, "Liked it"],
    [2, "Loved it"],
    [3, "The Best"]
  ]

  belongs_to :article
  belongs_to :user

  validates :user_id, :article_id, presence: true
  validates :user_rating,
    allow_blank: true,
    numericality: { only_integer: true },
    inclusion: { in: RATINGS.map { |rating| rating[0] } }

end
