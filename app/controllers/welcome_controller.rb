class WelcomeController < ApplicationController
  def index
    @ratings_collection = ArticlesUser::RATINGS

    if current_user && current_user.admin?
      if params[:api_search]
        @books_from_api = Book.save_data_from_api(params[:api_search])
        if @books_from_api.blank?
          @empty_search_result = "Either search results are already in the database or no results found!"
        end
      end
    end
    if current_user
      @user = User.find(current_user.id)
      # get articles
      @articles = ArticlesUser.includes(:article).where.not(articles_users: { user_id: @user.id }).where(articles_users: { access: "public" }).order(created_at: :desc)
      if @articles.blank?
        @empty_msg = "Sorry! No article-bookmarks available in public domain."
      else
        @articles = @articles.uniq(&:article_id)
        # remove the bookmarks that are saved by others as well as current_user
        sql = "select article_id from articles_users where article_id in (select article_id  from articles_users group by article_id having count(*) > 1) and user_id = #{current_user.id}"
        @articles_to_exclude = ActiveRecord::Base.connection.exec_query(sql)
        if @articles_to_exclude.length == @articles.length
          @empty_msg = "Sorry! No article-bookmarks available in public domain."
        end
      end

      #get Books
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

    elsif !user_signed_in?
      @articles = ArticlesUser.includes(:article).where(articles_users: { access: "public" }).order(created_at: :desc).limit(5)
      if @articles.blank?
        @empty_msg = "Sorry! No article-bookmarks available in public domain."
      else
        @articles = @articles.uniq(&:article_id)
      end

      @books = BooksUser.includes(:book).order(created_at: :desc)
      if @books.blank?
        @empty_msg_books = "None has bookmarked any books yet!. Please go to the books section to search a book."
      else
        @books = @books.uniq(&:book_id)
      end
    end

  end
end
