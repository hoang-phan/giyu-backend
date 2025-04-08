require 'rails_helper'

RSpec.describe 'Api::V1::Users', type: :request do
  include_context 'v1 request context'

  describe 'GET /api/v1/users' do
    let!(:users) { create_list(:user, 3) }

    it 'returns a list of users' do
      get '/api/v1/users', headers: headers
      expect(response).to have_http_status(:ok)
      expect(list_response(%w[id])).to eq(users.map(&:id).map(&:to_s))
      expect(list_response(%w[attributes code])).to eq(users.map(&:code))
      expect(list_response(%w[attributes phone])).to eq(users.map(&:phone))
    end
  end

  describe 'GET /api/v1/users/:id' do
    let(:user) { create(:user) }

    context 'when the user exists' do
      it 'returns the user' do
        get "/api/v1/users/#{user.id}", headers: headers
        expect(response).to have_http_status(:ok)
        expect(data_response['id']).to eq(user.id.to_s)
        expect(data_response['attributes']['code']).to eq(user.code)
        expect(data_response['attributes']['phone']).to eq(user.phone)
      end
    end

    context 'when the user does not exist' do
      it 'returns not found status' do
        get '/api/v1/users/0', headers: headers
        expect(response).to have_http_status(:not_found)
        expect(json_response['errors']).to eq([ 'Record not found' ])
      end
    end
  end

  describe 'POST /api/v1/users' do
    let(:valid_params) do
      {
        user: {
          code: 'USER123',
          phone: '+1234567890'
        }
      }
    end

    context 'with valid parameters' do
      let(:new_user) { User.last }

      it 'creates a new user' do
        expect {
          post '/api/v1/users', params: valid_params.to_json, headers: headers
        }.to change(User, :count).by(1)

        expect(response).to have_http_status(:created)
        expect(data_response['attributes']['code']).to eq('USER123')
        expect(data_response['attributes']['phone']).to eq('+1234567890')
        expect(new_user.code).to eq('USER123')
        expect(new_user.phone).to eq('+1234567890')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_params) do
        {
          user: {
            code: '',
            phone: ''
          }
        }
      end

      it 'returns unprocessable entity status' do
        post '/api/v1/users', params: invalid_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'PUT /api/v1/users/:id' do
    let(:user) { create(:user) }
    let(:update_params) do
      {
        user: {
          code: 'UPDATED123',
          phone: '+9876543210'
        }
      }
    end

    context 'with valid parameters' do
      it 'updates the user' do
        put "/api/v1/users/#{user.id}", params: update_params.to_json, headers: headers
        expect(response).to have_http_status(:no_content)
        expect(user.reload.code).to eq('UPDATED123')
        expect(user.reload.phone).to eq('+9876543210')
      end
    end

    context 'with invalid parameters' do
      let(:invalid_update_params) do
        {
          user: {
            code: '',
            phone: ''
          }
        }
      end

      it 'returns unprocessable entity status' do
        put "/api/v1/users/#{user.id}", params: invalid_update_params.to_json, headers: headers
        expect(response).to have_http_status(:unprocessable_entity)
      end
    end
  end

  describe 'DELETE /api/v1/users/:id' do
    let!(:user) { create(:user) }

    it 'deletes the user' do
      expect {
        delete "/api/v1/users/#{user.id}", headers: headers
      }.to change(User, :count).by(-1)

      expect(response).to have_http_status(:no_content)
    end
  end
end
