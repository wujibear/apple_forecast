class AddNanoidToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :nanoid, :string
    add_index :users, :nanoid, unique: true
  end
end 