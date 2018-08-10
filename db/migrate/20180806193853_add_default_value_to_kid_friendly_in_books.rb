class AddDefaultValueToKidFriendlyInBooks < ActiveRecord::Migration[5.2]
  def up
    change_column :books, :kid_friendly, :boolean, default: false
  end

  def down
    change_column :books, :kid_friendly, :boolean, default: nil
  end
end
