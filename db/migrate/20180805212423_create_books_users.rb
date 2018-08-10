class CreateBooksUsers < ActiveRecord::Migration[5.2]
  def change
    create_table :books_users do |t|
      t.integer :user_id, null: false
      t.integer :book_id, null: false
      t.string :user_rating
      t.string :access, default: "public"
      t.string :status, default: "read"

      t.timestamps null: false
    end
  end
end
