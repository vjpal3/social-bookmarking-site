class BooksController < ApplicationController
  def index
    if current_user
      @user = User.find(current_user.id)
    end
    @ratings_collection = BooksUser::RATINGS

    if (current_user && params[:show_available])
      # remove the bookmarks that are saved by the current user and may or may not be saved by others.
      @books =BooksUser.includes(:book).where.not(books_users: { user_id: @user.id }).order(created_at: :desc)
      if @books.blank?
        @empty_msg_books = "Sorry! No User has bookmarked any book yet! Be the first to bookmark a book."
      else
        @books = @books.uniq(&:book_id)
        # remove the bookmarks that are saved by current_user as well as others
        sql = "select book_id from books_users where book_id in (select book_id  from books_users group by book_id having count(*) > 1) and user_id = #{current_user.id}"
        @books_to_exclude = ActiveRecord::Base.connection.exec_query(sql)
        if @books_to_exclude.count == @books.count
          @empty_msg_books = "Sorry! No User has bookmarked any book yet! Be the first to bookmark a book."
        end
      end

    elsif current_user
      @books = BooksUser.includes(:book).where(books_users: { user_id: @user.id }).order(created_at: :desc)
      if @books.blank?
        @empty_msg_books = "Sorry! You have not bookmarked any books yet! Please click the links (+) above to create bookmarks"
      end
    elsif !user_signed_in?
      @books = BooksUser.includes(:book).order(created_at: :desc)
      if @books.blank?
        @empty_msg_books = "None has bookmarked any books yet!. Please go to the books section to search a book."
      else
        @books = @books.uniq(&:book_id)
      end
    end

  end

  def search
    if params[:book_search]
      @books = Book.where("title ILIKE ? OR authors ILIKE ? OR description ILIKE ?", "%#{params[:book_search]}%", "%#{params[:book_search]}%", "%#{params[:book_search]}%")
    elsif params[:book_category_search]
      @books = Book.where("categories ILIKE ?", "%#{params[:book_category_search]}%")
    end

    if @books.blank?
      @empty_msg_books = "Sorry! no results matched your query."
    end
  end

end
