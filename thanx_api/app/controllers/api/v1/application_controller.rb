module Api
  module V1
    class ApplicationController < ActionController::API
      include Authentication
      
      before_action :set_default_format
      
      private
      
      def set_default_format
        request.format = :json
      end
      
      def render_error(message, status: :unprocessable_entity)
        render json: { error: message }, status: status
      end
      
      def render_success(data = {}, status: :ok)
        render json: data, status: status
      end
    end
  end
end 