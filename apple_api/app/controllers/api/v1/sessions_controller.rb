module Api
  module V1
    class SessionsController < ApplicationController
      allow_unauthenticated_access only: %i[ create ]
      rate_limit to: 10, within: 3.minutes, only: :create, with: :render_too_many_requests

      def create
        user = created_user
        unless user
          render_unprocessable_entity("Invalid email address or password")
          return
        end

        start_new_session_for user

        render json: Api::V1::UserSerializer.render_as_json(user, view: :detail), status: :created
      end

      def destroy
        terminate_session

        head :no_content
      end

      private

      def authenticate_params
        params.permit(:email_address, :password)
      end

      def created_user
        @created_user ||= User.authenticate_by(authenticate_params)
      end
    end
  end
end
