module Api
  module V1
    class IceCreamsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      protected

      def collection
        @ice_creams ||= IceCream.includes(:line_items)
      end

      private

      def permitted_params
        params.permit(ice_cream: %i[fixed_price])
      end
    end
  end
end
