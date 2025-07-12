module Api
  module V1
    class RewardsController < ApplicationController
      def index
        rewards = Reward.all

        render json: Api::V1::RewardSerializer.render_as_json(rewards, view: :summary)
      end

      def show
        render json: Api::V1::RewardSerializer.render_as_json(reward, view: :detail)
      end

      def redeem
        redemption = RedeemReward.new(current_user, reward).call

        render json: Api::V1::RedemptionSerializer.render_as_json(redemption, view: :detail), status: :created
      end

      private

      def reward
        @reward ||= Reward.find(params[:id])
      end
    end
  end
end
