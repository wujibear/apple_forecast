class AddRewardNameToRedemptions < ActiveRecord::Migration[8.0]
  def change
    add_column :redemptions, :reward_name, :string
  end
end
