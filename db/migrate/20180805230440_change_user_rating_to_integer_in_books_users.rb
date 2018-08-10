class ChangeUserRatingToIntegerInBooksUsers < ActiveRecord::Migration[5.2]
  def change
    change_column :books_users, :user_rating, 'integer USING CAST(user_rating AS integer)'
  end
end
