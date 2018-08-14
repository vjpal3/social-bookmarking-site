class ArticlesController < ApplicationController
  before_action :authorize_user, except: [:index]

  def index
    if params[:search]
      @articles = ArticlesUser.includes(:article).where("tags ILIKE ?", "%#{params[:search]}%").references(:articles).where(articles_users: { access: "public" }).order(created_at: :desc)
      if @articles.blank?
        @empty_msg_articles = "Sorry! No matches found for the tags #{params[:search]}."
      else
        @articles = @articles.uniq(&:article_id)
      end
      @search_msg = params[:search]

    else
      if current_user
        @user = User.find(current_user.id)
      end
      #if current_user clicks 'Browse articles book,arked by others'
      if (current_user && params[:show_available])
        # remove the bookmarks that are saved by the current user and may or may not be saved by others.
        @articles = ArticlesUser.includes(:article).where.not(articles_users: { user_id: @user.id }).where(articles_users: { access: "public" }).order(created_at: :desc)
        if @articles.blank?
          @empty_msg_articles = "Sorry! No article-bookmarks available in public domain."
        else
          @articles = @articles.uniq(&:article_id)
          # remove the bookmarks that are saved by others as well as current_user
          sql = "select article_id from articles_users where article_id in (select article_id  from articles_users group by article_id having count(*) > 1) and user_id = #{current_user.id}"
          @articles_to_exclude = ActiveRecord::Base.connection.exec_query(sql)
          if @articles_to_exclude.length == @articles.length
            @empty_msg_articles = "Sorry! No article-bookmarks available in public domain."
          end
        end
        @msg_access = "show public access"

      elsif current_user
        @articles = ArticlesUser.includes(:article).where(articles_users: { user_id: @user.id }).order(created_at: :desc)
        if @articles.blank?
          @empty_msg_articles = "Sorry! You have not bookmarked any article yet! Please click the links (+) above to create bookmarks"
        else
          @msg_access = "show private access"
        end

      elsif !user_signed_in?
        @articles = ArticlesUser.includes(:article).where(articles_users: { access: "public" }).order(created_at: :desc)

        if @articles.blank?
          @empty_msg_articles = "Sorry! No article-bookmarks available in public domain."
        else
          @articles = @articles.uniq(&:article_id)
        end
      end
   end
   @ratings_collection = ArticlesUser::RATINGS
  end

  def show
    @article = Article.find(params[:id])
    @user = User.find(current_user.id)
    @articles_user = ArticlesUser.where("article_id = ? and user_id = ?", @article.id, @user.id).first
    @ratings_collection = ArticlesUser::RATINGS
  end

  def new
    @article = Article.new
    @articles_user = ArticlesUser.new
    @ratings_collection = ArticlesUser::RATINGS
  end

  def edit
    @user = User.find(current_user.id)
    @article = Article.find(params[:id])
    @articles_user = ArticlesUser.where("article_id = ? and user_id = ?", @article.id, @user.id).first
    @ratings_collection = ArticlesUser::RATINGS
  end

  def create
    @user = User.find(current_user.id)
    @article = Article.new(articles_params)

    host = URI.parse(params[:article][:url]).host
    if !host.nil?
      @article.host = host.start_with?('www.') ? host[4..-1] : host
    end
    @article.shared_by = @user.id
    @ratings_collection = ArticlesUser::RATINGS
    @articles_user = ArticlesUser.new(articles_users_params)

    if @article.save
      @articles_user.user = @user
      @articles_user.article = @article
      if @articles_user.save
        redirect_to @article, notice: 'Bookmark was successfully added.'
      else
        render 'new'
      end
    else
      render 'new'
    end
  end

  def update
    @ratings_collection = ArticlesUser::RATINGS
    @user = User.find(current_user.id)
    @article = Article.find(params[:id])

    host = URI.parse(params[:article][:url]).host
    if !host.nil?
      @article.host = host.start_with?('www.') ? host[4..-1] : host
    end

    @articles_user = ArticlesUser.where("article_id = ? and user_id = ?", @article.id, @user.id).first
    if @article.update(articles_params) && @articles_user.update(articles_users_params)
      redirect_to @article, notice: 'Bookmark was updated successfully.'
    else
      render 'edit'
    end
  end

  private
    def articles_params
      params.require(:article).permit(:title, :url, :tags)
    end

    def articles_users_params
      params.require(:articles_user).permit(:user_rating, :access, :status)
    end

  def authorize_user
    if !user_signed_in?
      flash[:notice] = "Sign in required before proceeding."
      redirect_to new_user_session_path
    end
  end
end
