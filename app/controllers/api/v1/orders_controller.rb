module Api
  module V1
    class OrdersController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      def transition_status
        service = OrderStatusTransitionService.new(resource, params[:event])
        if service.call
          render json: resource
        else
          render json: { error: service.error }, status: :unprocessable_entity
        end
      end

      private

      def permitted_params
        params.permit(order: %i[status])
      end
    end
  end
end
