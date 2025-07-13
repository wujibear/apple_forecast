class PopulateRewardNameInRedemptions < ActiveRecord::Migration[8.0]
  def up
    execute <<-SQL
      UPDATE redemptions 
      SET reward_name = (
        SELECT name 
        FROM rewards 
        WHERE rewards.id = redemptions.reward_id
      )
    SQL
  end

  def down
  end
end 