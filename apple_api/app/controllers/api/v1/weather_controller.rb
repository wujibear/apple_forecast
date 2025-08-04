module Api
  module V1
    class WeatherController < ApplicationController
      def create
        address = params[:address]
        
        if address.blank?
          render json: { error: 'Address is required' }, status: :bad_request
          return
        end
        
        weather_service = OpenWeatherService.new
        weather_data = weather_service.get_weather_by_address(address)
        
        if weather_data[:error]
          render json: { error: weather_data[:error] }, status: :not_found
        else
          render json: weather_data, status: :ok
        end
      end

      private def address
        params.permit[:address]
      end
    end
  end
end 