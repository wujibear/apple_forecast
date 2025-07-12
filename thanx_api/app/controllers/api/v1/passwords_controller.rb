module Api
  module V1
    class PasswordsController < ApplicationController
      allow_unauthenticated_access
      before_action :set_user_by_token, only: %i[ update ]

      rescue_from ActiveSupport::MessageVerifier::InvalidSignature, with: :render_unprocessable_entity

      def create
        PasswordsMailer.reset(user_to_request_reset).deliver_later if user_to_request_reset

        head :accepted
      end

      def update
        user_by_password_reset_token.update!(params.permit(:password, :password_confirmation))

        head :no_content
      end

      private

      def user_by_password_reset_token
        @user_by_password_reset_token ||= User.find_by_password_reset_token!(params[:token])
      end

      def user_to_request_reset
        @user_to_request_reset ||= User.find_by(email_address: params[:email_address])
      end
    end
  end
end
