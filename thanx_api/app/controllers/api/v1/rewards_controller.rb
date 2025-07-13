module Api
  module V1
    class RewardsController < ApplicationController
      allow_unauthenticated_access only: %i[ index show ]
      
      def index
        rewards = Reward.all

        render json: Api::V1::RewardSerializer.render_as_json(rewards, view: :summary)
      end

      def show
        render json: Api::V1::RewardSerializer.render_as_json(reward, view: :detail)
      end

      private

      def reward
        @reward ||= Reward.find_by!(nanoid: params[:id])
      end
    end
  end
end
