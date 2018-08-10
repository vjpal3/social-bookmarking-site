class ArticlesUsersController < ApplicationController
  before_action :authorize_user

  def create
    user = User.find(current_user.id)
    articles_user = ArticlesUser.find(params[:article_user_data])
    if params[:save]
      articles_user_new = ArticlesUser.new(user_id: user.id, article_id: articles_user.article_id)
    elsif params[:save_to_do]
      articles_user_new = ArticlesUser.new(user_id: user.id, article_id: articles_user.article_id, status: "To-do")
    end

    if articles_user_new.save
      redirect_to articles_path, notice: 'Bookmark was successfully saved.'
    else
      redirect_to articles_path, notice: 'An error occured while saving the bookmark.'
    end
  end

  def destroy
    @user = User.find(current_user.id)
    @articles_user = ArticlesUser.find(params[:id])
    @articles_user.destroy
    redirect_to articles_path, notice: 'Bookmark was deleted successfully.'
  end

  private
    def authorize_user
      if !user_signed_in?
        flash[:notice] = "Sign in required before proceeding."
        redirect_to new_user_session_path
      end
    end

end
