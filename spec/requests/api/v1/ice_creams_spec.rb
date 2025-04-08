require 'rails_helper'

RSpec.describe 'Api::V1::IceCreams', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/ice_creams' do
    let!(:ice_creams) { create_list(:ice_cream, 3) }

    it 'returns a list of ice creams' do
      get '/api/v1/ice_creams', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(ice_creams.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes fixed_price])).to eq(ice_creams.map(&:fixed_price))
    end
  end

  describe 'GET /api/v1/ice_creams/:id' do
    let(:ice_cream) { create(:ice_cream) }

    context 'when the ice cream exists' do
      it 'returns the ice cream' do
        get "/api/v1/ice_creams/#{ice_cream.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(ice_cream.id.to_s)
        expect(data_response['attributes']['fixed_price']).to eq(ice_cream.fixed_price)
      end
    end

    context 'when the ice cream does not exist' do
      it 'returns not found status' do
        get '/api/v1/ice_creams/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/ice_creams' do
    let(:valid_params) do
      {
        ice_cream: {
          fixed_price: 1000
        }
      }
    end

    context 'with valid parameters' do
      let(:new_ice_cream) { IceCream.last }

      it 'creates a new ice cream' do
        expect {
          post '/api/v1/ice_creams', params: valid_params.to_json, headers: headers
        }.to change(IceCream, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(new_ice_cream.fixed_price).to eq(1000)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          ice_cream: {
            fixed_price: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/ice_creams', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']['fixed_price']).to eq([ 'must be greater than or equal to 0' ])
      end
    end
  end

  describe 'PUT /api/v1/ice_creams/:id' do
    let(:ice_cream) { create(:ice_cream) }
    let(:update_params) do
      {
        ice_cream: {
          fixed_price: 1500
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the ice cream' do
        put "/api/v1/ice_creams/#{ice_cream.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(ice_cream.reload.fixed_price).to eq(1500)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          ice_cream: {
            fixed_price: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/ice_creams/#{ice_cream.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
        expect(json_response['errors']['fixed_price']).to eq([ 'must be greater than or equal to 0' ])
      end
    end
  end

  describe 'DELETE /api/v1/ice_creams/:id' do
    let!(:ice_cream) { create(:ice_cream) }

    it 'deletes the ice cream' do
      expect {
        delete "/api/v1/ice_creams/#{ice_cream.id}", headers: headers
      }.to change(IceCream, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
