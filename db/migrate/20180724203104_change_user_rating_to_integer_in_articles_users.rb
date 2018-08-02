class ChangeUserRatingToIntegerInArticlesUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :articles_users, :user_rating, 'integer USING CAST(user_rating AS integer)'
  end
end
