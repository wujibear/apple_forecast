class CreateRedemptions < ActiveRecord::Migration[8.0]
  def change
    create_table :redemptions do |t|
      t.references :user, null: false
      t.references :reward, null: false
      t.integer :points_cost, null: false
      t.timestamps
    end

    add_index :redemptions, [:user_id, :reward_id]
  end
end
