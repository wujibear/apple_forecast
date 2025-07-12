class AddPointsBalanceToUsers < ActiveRecord::Migration[8.0]
  def change
    add_column :users, :points_balance, :integer, default: 0
  end
end
