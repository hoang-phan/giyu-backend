module Api
  module V1
    class IceCreamFlavorsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      private

      def permitted_params
        params.permit(ice_cream_flavor: %i[ice_cream_id flavor_id quantity])
      end
    end
  end
end 