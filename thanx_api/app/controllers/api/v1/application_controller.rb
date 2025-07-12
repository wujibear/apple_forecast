module Api
  module V1
    class ApplicationController < ActionController::API
      include Authentication

      before_action :set_default_format

      # Handle common exceptions with appropriate HTTP status codes
      rescue_from ActiveRecord::RecordNotFound, with: :render_not_found
      rescue_from ActiveRecord::RecordInvalid, with: :render_unprocessable_entity
      rescue_from ActionController::ParameterMissing, with: :render_bad_request
      rescue_from StandardError, with: :render_internal_server_error

      private

      def set_default_format
        request.format = :json
      end

      # Specific error handlers
      def render_not_found(exception)
        render json: {
          error: "not_found",
          message: exception.message
        }, status: :not_found
      end

      def render_unprocessable_entity(exception)
        render json: {
          error: "unprocessable_entity",
          message: exception.message,
          details: exception.record&.errors&.full_messages
        }, status: :unprocessable_entity
      end

      def render_bad_request(exception)
        render json: {
            error: "bad_request",
            message: exception.message
        }, status: :bad_request
      end

      def render_too_many_requests
        render json: {
          error: "too_many_requests",
          message: "Login failed. Too many requests"
        }, status: :too_many_requests
      end

      def render_internal_server_error(exception)
        # Log the full error for debugging
        Rails.logger.error "Internal Server Error: #{exception.message}"
        Rails.logger.error exception.backtrace.join("\n")

        # In production, don't expose internal error details
        error_message = Rails.env.production? ? "Internal server error" : exception.message

        render json: {
          error: "internal_server_error",
          message: error_message
        }, status: :internal_server_error
      end
    end
  end
end
