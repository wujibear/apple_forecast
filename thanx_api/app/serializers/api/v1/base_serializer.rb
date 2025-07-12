module Api
  module V1
    class BaseSerializer < Blueprinter::Base
      fields :created_at, :updated_at

      # Common view options
      view :summary do
        # Minimal fields for list views
      end

      view :detail do
        include_view :summary
        # Additional fields for detail views
      end
    end
  end
end 