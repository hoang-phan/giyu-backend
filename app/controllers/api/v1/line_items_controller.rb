module Api
  module V1
    class LineItemsController < Api::BaseController
      actions :index, :show, :create, :update, :destroy

      protected

      def collection
        @line_items ||= end_of_association_chain.includes(:order, :product)
      end

      private

      def permitted_params
        params.permit(line_item: %i[order_id product_id quantity discount_percent])
      end
    end
  end
end
