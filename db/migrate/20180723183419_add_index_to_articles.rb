class AddIndexToArticles < ActiveRecord::Migration[5.2]
  def change
    add_index :articles, :url, unique: true
  end
end
