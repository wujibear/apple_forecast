module Api
  module V1
    class RewardSerializer < BaseSerializer
      identifier :id

      view :summary do
        fields :name, :points
      end

      view :detail do
        include_view :summary
        association :redemptions, blueprint: RedemptionSerializer
      end
    end
  end
end 