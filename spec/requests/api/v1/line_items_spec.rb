require 'rails_helper'

RSpec.describe 'Api::V1::LineItems', type: :request do
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:json_response) { JSON(response.body) }
  let(:data_response) { json_response['data'] }

  describe 'GET /api/v1/line_items' do
    let!(:line_items) { create_list(:line_item, 3) }

    def list_response(key_chain)
      data_response.map { |item| item.dig(*key_chain) }
    end

    it 'returns a list of line items' do
      get '/api/v1/line_items', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(line_items.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes quantity])).to eq(line_items.map(&:quantity))
    end
  end

  describe 'GET /api/v1/line_items/:id' do
    let(:line_item) { create(:line_item) }

    context 'when the line item exists' do
      it 'returns the line item' do
        get "/api/v1/line_items/#{line_item.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(line_item.id.to_s)
        expect(data_response['attributes']['quantity']).to eq(line_item.quantity)
      end
    end

    context 'when the line item does not exist' do
      it 'returns not found status' do
        get '/api/v1/line_items/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq(['Record not found'])
      end
    end
  end

  describe 'POST /api/v1/line_items' do
    let(:order) { create(:order) }
    let(:product) { create(:product) }
    let(:valid_params) do
      {
        line_item: {
          order_id: order.id,
          product_id: product.id,
          quantity: 2,
          discount_percent: 10
        }
      }
    end

    context 'with valid parameters' do
      let(:new_line_item) { LineItem.last }

      it 'creates a new line item' do
        expect {
          post '/api/v1/line_items', params: valid_params.to_json, headers: headers
        }.to change(LineItem, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(new_line_item.order_id).to eq(order.id)
        expect(new_line_item.product_id).to eq(product.id)
        expect(new_line_item.quantity).to eq(2)
        expect(new_line_item.discount_percent).to eq(10)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          line_item: {
            order_id: order.id,
            product_id: product.id,
            quantity: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/line_items', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/line_items/:id' do
    let(:line_item) { create(:line_item) }
    let(:update_params) do
      {
        line_item: {
          quantity: 5,
          discount_percent: 15
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the line item' do
        put "/api/v1/line_items/#{line_item.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(line_item.reload.quantity).to eq(5)
        expect(line_item.reload.discount_percent).to eq(15)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          line_item: {
            quantity: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/line_items/#{line_item.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/line_items/:id' do
    let!(:line_item) { create(:line_item) }

    it 'deletes the line item' do
      expect {
        delete "/api/v1/line_items/#{line_item.id}", headers: headers
      }.to change(LineItem, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end 