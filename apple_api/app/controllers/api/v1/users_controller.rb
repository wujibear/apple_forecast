module Api
  module V1
    class UsersController < ApplicationController
      # This controller requires authentication for all actions
      # No allow_unauthenticated_access call means all actions require login

      def show
        render json: Api::V1::UserSerializer.render_as_json(Current.user, view: :detail)
      end

      def update
        Current.user.update!(user_params)

        render json: Api::V1::UserSerializer.render_as_json(Current.user, view: :detail)
      end

      private

      def user_params
        params.permit(:email_address)
      end
    end
  end
end
