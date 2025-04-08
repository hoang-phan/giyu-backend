RSpec.shared_context 'v1 request context' do
  let(:headers) { { 'Content-Type' => 'application/json' } }
  let(:json_response) { JSON(response.body) }
  let(:data_response) { json_response['data'] }

  def list_response(key_chain)
    data_response.map { |item| item.dig(*key_chain) }
  end
end
