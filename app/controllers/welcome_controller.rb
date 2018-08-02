class WelcomeController < ApplicationController
  def index
    @articles = ArticlesUser.includes(:article).where(articles_users: { access: "public" }).order(created_at: :desc).limit(5)
    if @articles.blank?
      @empty_msg = "Sorry! No article-bookmarks available in public domain."
    end
    @ratings_collection = ArticlesUser::RATINGS
  end
end
