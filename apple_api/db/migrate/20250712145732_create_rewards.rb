class CreateRewards < ActiveRecord::Migration[8.0]
  def change
    create_table :rewards do |t|
      t.string :name, null: false
      t.integer :points, null: false
      t.timestamps
    end

    # For SQLite3, we can add the index immediately since it's a new table
    # No need for algorithm: :concurrently as SQLite3 doesn't support it
    add_index :rewards, :name, unique: true
  end
end
