require 'rails_helper'

RSpec.describe 'Api::V1::Orders', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/orders' do
    let!(:orders) { create_list(:order, 3) }

    it 'returns a list of orders' do
      get '/api/v1/orders', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(orders.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes status])).to eq(orders.map(&:status))
    end
  end

  describe 'GET /api/v1/orders/:id' do
    let(:order) { create(:order) }

    context 'when the order exists' do
      it 'returns the order' do
        get "/api/v1/orders/#{order.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(order.id.to_s)
        expect(data_response['attributes']['status']).to eq(order.status)
      end
    end

    context 'when the order does not exist' do
      it 'returns not found status' do
        get '/api/v1/orders/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/orders' do
    let(:valid_params) do
      {}
    end

    context 'with valid parameters' do
      let(:new_order) { Order.last }

      it 'creates a new order' do
        expect {
          post '/api/v1/orders', params: valid_params.to_json, headers: headers
        }.to change(Order, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(data_response['attributes']['status']).to eq('ordering')
        expect(new_order.status).to eq('ordering')
      end
    end
  end

  describe 'PUT /api/v1/orders/:id' do
    let(:order) { create(:order) }
    let(:update_params) do
      {
        order: {
          status: 'queueing'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the order' do
        put "/api/v1/orders/#{order.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(order.reload.status).to eq('queueing')
      end
    end
  end

  describe 'DELETE /api/v1/orders/:id' do
    let!(:order) { create(:order) }

    it 'deletes the order' do
      expect {
        delete "/api/v1/orders/#{order.id}", headers: headers
      }.to change(Order, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end

  describe 'POST /api/v1/orders/:id/transition_status' do
    let(:order) { create(:order) }
    let(:transition_params) { { event: 'confirm' } }

    context 'with valid transition' do
      it 'transitions the order status' do
        post "/api/v1/orders/#{order.id}/transition_status", params: transition_params.to_json, headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['attributes']['status']).to eq('waiting_payment')
      end
    end

    context 'with invalid event' do
      let(:invalid_event_params) { { event: 'invalid_event' } }

      it 'returns unprocessable entity status' do
        post "/api/v1/orders/#{order.id}/transition_status", params: invalid_event_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq "Event :invalid_event! doesn't exist"
      end
    end

    context 'with invalid transition' do
      let(:invalid_transition_params) { { event: 'start_production' } }

      it 'returns unprocessable entity status' do
        post "/api/v1/orders/#{order.id}/transition_status", params: invalid_transition_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['error']).to eq "Event 'start_production' cannot transition from 'ordering'."
      end
    end
  end
end
