class ApplicationController < ActionController::API
  # This is now the base controller for non-API controllers
  # API controllers should inherit from Api::V1::ApplicationController
end
