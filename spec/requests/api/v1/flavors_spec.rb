require 'rails_helper'

RSpec.describe 'Api::V1::Flavors', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/flavors' do
    let!(:flavors) { create_list(:flavor, 3) }

    it 'returns a list of flavors' do
      get '/api/v1/flavors', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(flavors.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes name])).to eq(flavors.map(&:name))
      expect(list_response(%w[attributes unit_price])).to eq(flavors.map(&:unit_price))
    end
  end

  describe 'GET /api/v1/flavors/:id' do
    let(:flavor) { create(:flavor) }

    context 'when the flavor exists' do
      it 'returns the flavor' do
        get "/api/v1/flavors/#{flavor.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(flavor.id.to_s)
        expect(data_response['attributes']['name']).to eq(flavor.name)
        expect(data_response['attributes']['unit_price']).to eq(flavor.unit_price)
      end
    end

    context 'when the flavor does not exist' do
      it 'returns not found status' do
        get '/api/v1/flavors/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/flavors' do
    let(:valid_params) do
      {
        flavor: {
          name: 'Vanilla',
          unit_price: 1000
        }
      }
    end

    context 'with valid parameters' do
      let(:new_flavor) { Flavor.last }

      it 'creates a new flavor' do
        expect {
          post '/api/v1/flavors', params: valid_params.to_json, headers: headers
        }.to change(Flavor, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(data_response['attributes']['name']).to eq('Vanilla')
        expect(data_response['attributes']['unit_price']).to eq(1000)
        expect(new_flavor.name).to eq('Vanilla')
        expect(new_flavor.unit_price).to eq(1000)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          flavor: {
            name: '',
            unit_price: 1000
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/flavors', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/flavors/:id' do
    let(:flavor) { create(:flavor) }
    let(:update_params) do
      {
        flavor: {
          name: 'Updated Vanilla',
          unit_price: 1500
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the flavor' do
        put "/api/v1/flavors/#{flavor.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(flavor.reload.name).to eq('Updated Vanilla')
        expect(flavor.reload.unit_price).to eq(1500)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          flavor: {
            name: '',
            unit_price: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/flavors/#{flavor.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/flavors/:id' do
    let!(:flavor) { create(:flavor) }

    it 'deletes the flavor' do
      expect {
        delete "/api/v1/flavors/#{flavor.id}", headers: headers
      }.to change(Flavor, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
