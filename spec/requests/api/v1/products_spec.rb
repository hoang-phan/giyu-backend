require 'rails_helper'

RSpec.describe 'Api::V1::Products', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/products' do
    let!(:products) { create_list(:product, 3) }

    it 'returns a list of products' do
      get '/api/v1/products', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(products.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes type])).to eq(products.map(&:type))
      expect(list_response(%w[attributes fixed_price])).to eq(products.map(&:fixed_price))
    end
  end

  describe 'GET /api/v1/products/:id' do
    let(:product) { create(:product) }

    context 'when the product exists' do
      it 'returns the product' do
        get "/api/v1/products/#{product.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(product.id.to_s)
        expect(data_response['attributes']['type']).to eq(product.type)
        expect(data_response['attributes']['fixed_price']).to eq(product.fixed_price)
      end
    end

    context 'when the product does not exist' do
      it 'returns not found status' do
        get '/api/v1/products/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/products' do
    let(:valid_params) do
      {
        product: {
          type: 'IceCream',
          fixed_price: 1099
        }
      }
    end

    context 'with valid parameters' do
      let(:new_product) { Product.last }

      it 'creates a new product' do
        expect {
          post '/api/v1/products', params: valid_params.to_json, headers: headers
        }.to change(Product, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(data_response['attributes']['type']).to eq('IceCream')
        expect(data_response['attributes']['fixed_price']).to eq(1099)
        expect(new_product.type).to eq('IceCream')
        expect(new_product.fixed_price).to eq(1099)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          product: {
            type: '',
            fixed_price: nil
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/products', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/products/:id' do
    let(:product) { create(:product) }
    let(:update_params) do
      {
        product: {
          type: 'IceCream',
          fixed_price: 1599
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the product' do
        put "/api/v1/products/#{product.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(product.reload.type).to eq('IceCream')
        expect(product.reload.fixed_price).to eq(1599)
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          product: {
            type: '',
            fixed_price: nil
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/products/#{product.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/products/:id' do
    let!(:product) { create(:product) }

    it 'deletes the product' do
      expect {
        delete "/api/v1/products/#{product.id}", headers: headers
      }.to change(Product, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
