class AddNanoidToRedemptions < ActiveRecord::Migration[8.0]
  def change
    add_column :redemptions, :nanoid, :string
    add_index :redemptions, :nanoid, unique: true
  end
end 