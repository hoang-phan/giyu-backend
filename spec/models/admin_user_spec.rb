require 'rails_helper'

RSpec.describe AdminUser, type: :model do
  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'email',
        'encrypted_password',
        'id',
        'id_value',
        'remember_created_at',
        'reset_password_sent_at',
        'reset_password_token',
        'updated_at'
      ]
      expect(AdminUser.ransackable_attributes).to match_array(expected_attributes)
    end
  end
end
