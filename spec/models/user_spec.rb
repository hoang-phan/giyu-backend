require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:phone) }
    it { is_expected.to validate_uniqueness_of(:phone) }
  end

  describe 'code generation' do
    let(:user) { build(:user, code:) }
    let(:code) { nil }

    context 'when code is absent' do
      it 'generates a code before validation' do
        expect(user.save).to be_truthy
        expect(user.reload.code).to be_present
        expect(user.code.length).to eq user.id.to_s.length * 2
      end
    end

    context 'when code is present' do
      let(:code) { '123456' }

      it 'does not regenerate code if one already exists' do
        expect { user.valid? }.not_to change { user.code }
      end
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'birth_day',
        'birth_month',
        'birth_year',
        'code',
        'created_at',
        'email',
        'first_name',
        'id',
        'id_value',
        'last_active_at',
        'last_name',
        'phone',
        'registration_date',
        'updated_at'
      ]
      expect(User.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns empty array' do
      expect(User.ransackable_associations).to be_empty
    end
  end
end 