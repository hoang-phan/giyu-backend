require 'rails_helper'

RSpec.describe Flavor, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:ice_cream_flavors).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'id',
        'id_value',
        'name',
        'unit_price',
        'updated_at'
      ]
      expect(Flavor.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns an empty array' do
      expect(Flavor.ransackable_associations).to be_empty
    end
  end
end 