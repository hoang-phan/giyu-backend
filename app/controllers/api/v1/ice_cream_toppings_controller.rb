module Api
  module V1
    class IceCreamToppingsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      private

      def permitted_params
        params.permit(ice_cream_topping: %i[ice_cream_id topping_id quantity])
      end
    end
  end
end
