require 'rails_helper'

RSpec.describe 'Api::V1::Toppings', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/toppings' do
    let!(:toppings) { create_list(:topping, 3) }

    it 'returns a list of toppings' do
      get '/api/v1/toppings', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(toppings.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes name])).to eq(toppings.map(&:name))
      expect(list_response(%w[attributes unit_price])).to eq(toppings.map(&:unit_price))
    end
  end

  describe 'GET /api/v1/toppings/:id' do
    let(:topping) { create(:topping) }

    context 'when the topping exists' do
      it 'returns the topping' do
        get "/api/v1/toppings/#{topping.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(topping.id.to_s)
        expect(data_response['attributes']['name']).to eq(topping.name)
        expect(data_response['attributes']['unit_price']).to eq(topping.unit_price)
      end
    end

    context 'when the topping does not exist' do
      it 'returns not found status' do
        get '/api/v1/toppings/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/toppings' do
    let(:valid_params) do
      {
        topping: {
          name: 'Sprinkles',
          unit_price: 1000
        }
      }
    end

    context 'with valid parameters' do
      let(:new_topping) { Topping.last }

      it 'creates a new topping' do
        expect {
          post '/api/v1/toppings', params: valid_params.to_json, headers: headers
        }.to change(Topping, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(data_response['attributes']['name']).to eq('Sprinkles')
        expect(data_response['attributes']['unit_price']).to eq(1000)
        expect(new_topping.name).to eq('Sprinkles')
        expect(new_topping.unit_price).to eq(1000)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          topping: {
            name: '',
            unit_price: 1000
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/toppings', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/toppings/:id' do
    let(:topping) { create(:topping) }
    let(:update_params) do
      {
        topping: {
          name: 'Updated Sprinkles',
          unit_price: 1500
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the topping' do
        put "/api/v1/toppings/#{topping.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(topping.reload.name).to eq('Updated Sprinkles')
        expect(topping.reload.unit_price).to eq(1500)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          topping: {
            name: '',
            unit_price: -1
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/toppings/#{topping.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/toppings/:id' do
    let!(:topping) { create(:topping) }

    it 'deletes the topping' do
      expect {
        delete "/api/v1/toppings/#{topping.id}", headers: headers
      }.to change(Topping, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
