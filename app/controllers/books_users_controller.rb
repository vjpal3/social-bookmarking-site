class BooksUsersController < ApplicationController
  before_action :authorize_user

  def create
    @ratings_collection = BooksUser::RATINGS
    user = User.find(current_user.id)
    book = Book.find(params[:book_data])
    if params[:save]
      books_user = BooksUser.new(user_id: user.id, book_id: book.id)
    # articles_user_new = ArticlesUser.new(user_id: user.id, article_id: articles_user.article_id)
    elsif params[:save_to_do]
      books_user = BooksUser.new(user_id: user.id, book_id: book.id, status: "To-do")
    end

    if books_user.save
      redirect_to books_path, notice: 'Bookmark was successfully saved.'
    else
      redirect_to books_path, notice: 'An error occured while saving the bookmark.'
    end
    @ratings_collection = BooksUser::RATINGS
  end

  def update
    #Updates here are using AJAX features.
    @ratings_collection = BooksUser::RATINGS
    @item = BooksUser.find(params[:id])
    if params[:change_status]
      if @item.update(status: params[:books_user]["status"])
        # redirect_to books_path, notice: 'Book-status was successfully updated.'
        render partial: "books/change_status_form", locals: {item: @item}
      end
    elsif params[:change_rating]
      if @item.update(books_users_params)
        # redirect_to books_path, notice: 'Book-rating was successfully updated.'
        render partial: "books/change_rating_form", locals: {item: @item}
      end
    end
  end

  def destroy
    @user = User.find(current_user.id)
    @books_user = BooksUser.find(params[:id])
    @books_user.destroy
    render "books/destroy.js.erb", locals: {item: params[:id]}
  end

  private
    def books_users_params
      params.require(:books_user).permit(:user_rating)
      # params.require(:articles_user).permit(:user_rating, :access, :status)
    end

    def authorize_user
      if !user_signed_in?
        flash[:notice] = "Sign in required before proceeding."
        redirect_to new_user_session_path
      end
    end
end
