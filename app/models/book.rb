class Book < ApplicationRecord
  has_many :books_users
  has_many :users, through: :books_users

  validates :title, :isbn_13, :publisher, :published_at, presence: true
  validates :isbn_13, uniqueness: true
  validates :kid_friendly, inclusion: { in: [true, false] }
  validates :approved, inclusion: { in: [true, false] }

  after_validation :log_errors, :if => Proc.new {|m| m.errors}

  def log_errors
    Rails.logger.debug self.errors.full_messages.join("\n")
  end

  def self.save_data_from_api(search)
    response = HTTParty.get('https://www.googleapis.com/books/v1/volumes?q=' + search)

    books = []
    if !response.nil?
      response["items"].each do |item|
        #if isbn info not avalable, then don't save the book. isbn_13 is a uniq field and helps to avoid duplicate data.
        isbn_data = item["volumeInfo"]["industryIdentifiers"]
        next if isbn_data.nil?

        book = Book.new
        book.isbn_13 = isbn_data[0]["identifier"]
        book.title = item["volumeInfo"]["title"]

        if !item["volumeInfo"]["authors"].nil?
          book.authors = item["volumeInfo"]["authors"].join(", ")
        end

        if !item["searchInfo"].nil?
          book.description = item["searchInfo"]["textSnippet"]
        else
          book.description = "N/A"
        end

        book.publisher = item["volumeInfo"]["publisher"]

        if !item["volumeInfo"]["publishedDate"].nil?
          book.published_at = item["volumeInfo"]["publishedDate"][0..3].to_i
        else
          book.published_at = 0
        end

        if !item["volumeInfo"]["categories"].nil?
          book.categories = item["volumeInfo"]["categories"][0]
        end

        book.googlebooks_rating = item["volumeInfo"]["averageRating"]

        if !item["volumeInfo"]["imageLinks"].nil?
          book.thumbnail_url = item["volumeInfo"]["imageLinks"]["smallThumbnail"]
        end

        if book.save
          books << book
        end
      end
    else
      puts "API response Nil"
    end
    books
  end
end
