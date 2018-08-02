class Article < ApplicationRecord
  has_many :articles_users
  has_many :users, through: :articles_users

  validates :title, :url, presence: true
  validates :url, uniqueness: true
  validates :url, format: URI::regexp(%w(http https))
  validates :kid_friendly, inclusion: { in: [true, false] }
  validates :approved, inclusion: { in: [true, false] }

  # def self.search(search)
  #   find(:all, :conditions => ['tags LIKE ?', "%#{search}%"]
  # end


end
