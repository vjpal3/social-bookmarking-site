class CreateArticles < ActiveRecord::Migration[5.2]
  def change
    create_table :articles do |t|
      t.string :title, null: false
      t.string :url, null: false
      t.string :host
      t.string :avg_rating
      t.string :tags
      t.boolean :kid_friendly, default: false
      t.boolean :approved, default: false
      t.integer :shared_by
      t.integer :approved_by

      t.timestamps null: false
    end
  end
end
