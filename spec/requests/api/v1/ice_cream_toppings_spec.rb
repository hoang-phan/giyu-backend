require 'rails_helper'

RSpec.describe 'Api::V1::IceCreamToppings', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/ice_cream_toppings' do
    let!(:ice_cream_toppings) { create_list(:ice_cream_topping, 3) }

    it 'returns a list of ice cream toppings' do
      get '/api/v1/ice_cream_toppings', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(ice_cream_toppings.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes quantity])).to eq(ice_cream_toppings.map(&:quantity))
    end
  end

  describe 'GET /api/v1/ice_cream_toppings/:id' do
    let!(:ice_cream_topping) { create(:ice_cream_topping) }

    it 'returns a single ice cream topping' do
      get "/api/v1/ice_cream_toppings/#{ice_cream_topping.id}", headers: headers
      expect(response).to have_http_status(:ok)
      expect(data_response['id']).to eq(ice_cream_topping.id.to_s)
      expect(data_response['attributes']['quantity']).to eq(ice_cream_topping.quantity)
    end
  end

  describe 'POST /api/v1/ice_cream_toppings' do
    let(:ice_cream) { create(:ice_cream) }
    let(:topping) { create(:topping) }
    let(:params) { { ice_cream_topping: { ice_cream_id: ice_cream.id, topping_id: topping.id, quantity: 1 } } }

    it 'creates a new ice cream topping' do
      post '/api/v1/ice_cream_toppings', headers: headers, params: params.to_json
      expect(response).to have_http_status(:created)
      expect(data_response['id']).to be_present
      expect(data_response['attributes']['quantity']).to eq(1)
    end
  end

  describe 'PUT /api/v1/ice_cream_toppings/:id' do
    let(:ice_cream_topping) { create(:ice_cream_topping) }
    let(:params) { { ice_cream_topping: { quantity: 2 } } }

    it 'updates the ice cream topping' do
      put "/api/v1/ice_cream_toppings/#{ice_cream_topping.id}", headers: headers, params: params.to_json
      expect(response).to have_http_status(:no_content)
      expect(ice_cream_topping.reload.quantity).to eq(2)
    end
  end

  describe 'DELETE /api/v1/ice_cream_toppings/:id' do
    let!(:ice_cream_topping) { create(:ice_cream_topping) }

    it 'deletes the ice cream topping' do
      expect {
        delete "/api/v1/ice_cream_toppings/#{ice_cream_topping.id}", headers: headers
      }.to change(IceCreamTopping, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
