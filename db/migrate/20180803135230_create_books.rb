class CreateBooks < ActiveRecord::Migration[5.2]
  def change
    create_table :books do |t|
      t.string :title, null: false
      t.string :isbn_13, null: false, unique: true
      t.string :authors
      t.text :description
      t.string :publisher, null: false
      t.integer :published_at, null: false
      t.integer :googlebooks_rating
      t.string :categories
      t.string :thumbnail_url
      t.boolean :kid_friendly
      t.boolean :approved
      t.integer :approved_by

      t.timestamps null: false
    end
  end
end
