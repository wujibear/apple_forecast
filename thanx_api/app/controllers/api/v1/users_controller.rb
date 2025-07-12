module Api
  module V1
    class UsersController < ApplicationController
      # This controller requires authentication for all actions
      # No allow_unauthenticated_access call means all actions require login

      def show
        # Current.user is available from the Authentication concern
        render_success({
          user: {
            id: Current.user.id,
            email_address: Current.user.email_address
          }
        })
      end

      def update
        if Current.user.update(user_params)
          render_success({
            message: "Profile updated successfully",
            user: {
              id: Current.user.id,
              email_address: Current.user.email_address
            }
          })
        else
          render_error("Failed to update profile", status: :unprocessable_entity)
        end
      end

      private

      def user_params
        params.permit(:email_address)
      end
    end
  end
end 