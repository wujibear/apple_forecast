module Api
  module V1
    class SessionsController < ApplicationController
      allow_unauthenticated_access only: %i[ create ]
      rate_limit to: 10, within: 3.minutes, only: :create, with: :render_too_many_requests

      def create
        raise ActiveRecord::RecordInvalid.new(User.new), "Invalid email address or password" unless created_user

        start_new_session_for created_user

        render json: Api::V1::UserSerializer.render_as_json(created_user, view: :detail), status: :created
      end

      def destroy
        terminate_session

        head :ok
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
