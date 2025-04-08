require 'rails_helper'

RSpec.describe 'Api::V1::IceCreamFlavors', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/ice_cream_flavors' do
    let!(:ice_cream_flavors) { create_list(:ice_cream_flavor, 3) }

    it 'returns a list of ice cream flavors' do
      get '/api/v1/ice_cream_flavors', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(ice_cream_flavors.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes quantity])).to eq(ice_cream_flavors.map(&:quantity))
    end
  end

  describe 'GET /api/v1/ice_cream_flavors/:id' do
    let(:ice_cream_flavor) { create(:ice_cream_flavor) }

    context 'when the ice cream flavor exists' do
      it 'returns the ice cream flavor' do
        get "/api/v1/ice_cream_flavors/#{ice_cream_flavor.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(ice_cream_flavor.id.to_s)
        expect(data_response['attributes']['quantity']).to eq(ice_cream_flavor.quantity)
      end
    end

    context 'when the ice cream flavor does not exist' do
      it 'returns not found status' do
        get '/api/v1/ice_cream_flavors/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/ice_cream_flavors' do
    let(:ice_cream) { create(:ice_cream) }
    let(:flavor) { create(:flavor) }
    let(:valid_params) do
      {
        ice_cream_flavor: {
          ice_cream_id: ice_cream.id,
          flavor_id: flavor.id,
          quantity: 2
        }
      }
    end

    context 'with valid parameters' do
      let(:new_ice_cream_flavor) { IceCreamFlavor.last }

      it 'creates a new ice cream flavor' do
        expect {
          post '/api/v1/ice_cream_flavors', params: valid_params.to_json, headers: headers
        }.to change(IceCreamFlavor, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(new_ice_cream_flavor.ice_cream_id).to eq(ice_cream.id)
        expect(new_ice_cream_flavor.flavor_id).to eq(flavor.id)
        expect(new_ice_cream_flavor.quantity).to eq(2)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          ice_cream_flavor: {
            ice_cream_id: ice_cream.id,
            flavor_id: flavor.id,
            quantity: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/ice_cream_flavors', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/ice_cream_flavors/:id' do
    let(:ice_cream_flavor) { create(:ice_cream_flavor) }
    let(:update_params) do
      {
        ice_cream_flavor: {
          quantity: 5
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the ice cream flavor' do
        put "/api/v1/ice_cream_flavors/#{ice_cream_flavor.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(ice_cream_flavor.reload.quantity).to eq(5)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          ice_cream_flavor: {
            quantity: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/ice_cream_flavors/#{ice_cream_flavor.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/ice_cream_flavors/:id' do
    let!(:ice_cream_flavor) { create(:ice_cream_flavor) }

    it 'deletes the ice cream flavor' do
      expect {
        delete "/api/v1/ice_cream_flavors/#{ice_cream_flavor.id}", headers: headers
      }.to change(IceCreamFlavor, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
