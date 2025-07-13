module Api
  module V1
    class RedemptionsController < ApplicationController
      def index
        redemptions = current_user.redemptions.order(created_at: :desc)
        
        render json: Api::V1::RedemptionSerializer.render_as_json(redemptions, view: :detail)
      end

      def create
        redemption = RedeemReward.new(current_user, reward).call

        render json: Api::V1::RedemptionSerializer.render_as_json(redemption, view: :detail), status: :created
      end

      private

      def reward
        @reward ||= Reward.find_by!(nanoid: params[:id])
      end
    end
  end
end 