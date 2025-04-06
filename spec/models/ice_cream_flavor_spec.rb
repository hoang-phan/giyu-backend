require 'rails_helper'

RSpec.describe IceCreamFlavor, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:ice_cream) }
    it { is_expected.to belong_to(:flavor) }
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'flavor_id',
        'id',
        'id_value',
        'ice_cream_id',
        'quantity',
        'updated_at'
      ]
      expect(IceCreamFlavor.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the correct ransackable associations' do
      expected_associations = ['flavor', 'ice_cream']
      expect(IceCreamFlavor.ransackable_associations).to match_array(expected_associations)
    end
  end
end 