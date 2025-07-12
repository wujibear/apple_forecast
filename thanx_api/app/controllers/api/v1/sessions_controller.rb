module Api
  module V1
    class SessionsController < ApplicationController
      allow_unauthenticated_access only: %i[ create ]
      rate_limit to: 10, within: 3.minutes, only: :create, with: :render_too_many_requests

      def create
        if user = User.authenticate_by(params.permit(:email_address, :password))
          start_new_session_for user
          render_success({
            message: "Login successful",
            user: {
              id: user.id,
              email_address: user.email_address
            }
          })
        else
          render_error("Invalid email address or password", status: :unauthorized)
        end
      end

      def destroy
        terminate_session
        render_success({ message: "Logged out successfully" })
      end
    end
  end
end 