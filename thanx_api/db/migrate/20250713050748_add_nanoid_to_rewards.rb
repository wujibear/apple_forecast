class AddNanoidToRewards < ActiveRecord::Migration[8.0]
  def change
    add_column :rewards, :nanoid, :string
    add_index :rewards, :nanoid, unique: true
  end
end 