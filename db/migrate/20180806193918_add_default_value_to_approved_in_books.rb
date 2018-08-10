class AddDefaultValueToApprovedInBooks < ActiveRecord::Migration[5.2]
  def up
    change_column :books, :approved, :boolean, default: false
  end

  def down
    change_column :books, :approved, :boolean, default: nil
  end
end
