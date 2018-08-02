class ArticlesController < ApplicationController
  before_action :authorize_user, except: [:index]

  def index
    if params[:search]
      @articles = ArticlesUser.includes(:article).where(articles: { tags: params[:search]} ).where(articles_users: { access: "public" }).order(created_at: :desc)
      if @articles.blank?
        @empty_msg = "Sorry! No matches found for the tags #{params[:search]}."
      end
      @search_msg = params[:search]

    else
      if current_user
        @user = User.find(current_user.id)
      end
      #if current_user clicks 'Browse all articles'
      if (current_user && params[:show_available])
        # @articles = Article.joins(:articles_users).where("articles_users.user_id != ?", @user.id).where(articles_users: { access: "public" }).order(created_at: :desc)
        @articles = ArticlesUser.includes(:article).where.not(articles_users: { user_id: @user.id }).where(articles_users: { access: "public" }).order(created_at: :desc)
        if @articles.blank?
          @empty_msg = "Sorry! No article-bookmarks available in public domain."
        end
        @msg_access = "show public access"

      elsif current_user
        @articles = ArticlesUser.includes(:article).where(articles_users: { user_id: @user.id }).order(created_at: :desc)
        if @articles.blank?
          @empty_msg = "Sorry! You have not bookmarked any article yet!"
        else
          @msg_access = "show private access"
        end

      elsif !user_signed_in?
        @articles = ArticlesUser.includes(:article).where(articles_users: { access: "public" }).order(created_at: :desc)
        if @articles.blank?
          @empty_msg = "Sorry! No article-bookmarks available in public domain."
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
        redirect_to @article, notice: 'Bookmark was successfully saved.'
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
      # redirect_to thing_path(@thing, foo: params[:foo])

      redirect_to @article, notice: 'Bookmark was updated successfully.'
    else
      render 'edit'
    end
  end

  def destroy
    @user = User.find(current_user.id)
    @article = Article.find(params[:id])
    @articles_user = ArticlesUser.where("article_id = ? and user_id = ?", @article.id, @user.id).first
    @article.destroy
    @articles_user.destroy
    redirect_to articles_path, notice: 'Bookmark was deleted successfully.'
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
      redirect_to root_path
    end
  end

end



#   def index
#     @items = Item.order(created_at: :desc)
#   end
#
#   def show
#     @item = Item.find(params[:id])
#     # Following line is required, otherwise, ActionView::Template::Error:
#     #   First argument in form cannot contain nil or be empty
#     @review = @item.reviews.build(params[:review])
#   end
#
#   def new
#     @item = Item.new
#   end
#
#   def edit
#     @item = Item.find(params[:id])
#   end
#
#
#
#   def update
      # @item = Item.find(params[:id])
      # if @item.update(items_params)
      #   redirect_to @item, notice: 'Item was successfully updated.'
      # else
      #   render 'edit'
      # end
#   end
#
#   def destroy
#     @item = Item.find(params[:id])
#     @item.destroy
#     redirect_to items_path
#   end
#
#
#
#
#
# end
