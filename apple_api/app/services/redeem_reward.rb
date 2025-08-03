class RedeemReward
  attr_reader :user, :reward

  def initialize(user, reward)
    @user = user
    @reward = reward
  end

  def call
    insufficient_points! unless user_has_sufficient_points?

    ActiveRecord::Base.transaction do
      redemption.save!
      user.update!(points_balance: new_points_balance)
    end

    redemption
  end

  private

  def user_has_sufficient_points?
    new_points_balance >= 0
  end

  def new_points_balance
    @new_points_balance ||= user.points_balance - reward.points
  end

  def insufficient_points!
    raise ActiveRecord::RecordInvalid.new(redemption), "insufficient_points"
  end

  def redemption
    @redemption ||= Redemption.new(user:, reward:, points_cost: reward.points)
  end
end
