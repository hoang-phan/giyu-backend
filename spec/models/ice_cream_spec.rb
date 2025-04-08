require 'rails_helper'

RSpec.describe IceCream, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:ice_cream_flavors).dependent(:destroy) }
    it { is_expected.to have_many(:flavors).through(:ice_cream_flavors) }
    it { is_expected.to have_many(:ice_cream_toppings).dependent(:destroy) }
    it { is_expected.to have_many(:toppings).through(:ice_cream_toppings) }
  end

  describe 'nested attributes' do
    it { is_expected.to accept_nested_attributes_for(:ice_cream_flavors).allow_destroy(true) }
    it { is_expected.to accept_nested_attributes_for(:ice_cream_toppings).allow_destroy(true) }
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'fixed_price',
        'id',
        'id_value',
        'price',
        'type',
        'updated_at'
      ]
      expect(IceCream.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns an empty array' do
      expect(IceCream.ransackable_associations).to be_empty
    end
  end

  describe '#to_s' do
    context 'when name is present' do
      let(:ice_cream) { build(:ice_cream, name: 'Vanilla Ice Cream') }

      it 'returns the name' do
        expect(ice_cream.to_s).to eq('Vanilla Ice Cream')
      end
    end

    context 'when name is not present' do
      let(:flavor1) { create(:flavor, name: 'Vanilla') }
      let(:flavor2) { create(:flavor, name: 'Chocolate') }
      let(:ice_cream) { create(:ice_cream) }
      let!(:ice_cream_flavor1) { create(:ice_cream_flavor, ice_cream: ice_cream, flavor: flavor1) }
      let!(:ice_cream_flavor2) { create(:ice_cream_flavor, ice_cream: ice_cream, flavor: flavor2) }

      it 'returns the concatenated flavor names' do
        expect(ice_cream.to_s).to eq('Vanilla + Chocolate')
      end
    end
  end

  describe '#price' do
    context 'when fixed_price is present' do
      let(:ice_cream) { build(:ice_cream, fixed_price: 1000) }

      it 'returns the fixed_price' do
        expect(ice_cream.price).to eq(1000)
      end
    end

    context 'when fixed_price is not present' do
      let(:flavor1) { create(:flavor, unit_price: 300) }
      let(:flavor2) { create(:flavor, unit_price: 200) }
      let(:topping1) { create(:topping, unit_price: 100) }
      let(:topping2) { create(:topping, unit_price: 50) }
      let(:ice_cream) { create(:ice_cream, fixed_price: nil) }
      let!(:ice_cream_flavor1) { create(:ice_cream_flavor, ice_cream: ice_cream, flavor: flavor1, quantity: 2) }
      let!(:ice_cream_flavor2) { create(:ice_cream_flavor, ice_cream: ice_cream, flavor: flavor2, quantity: 1) }
      let!(:ice_cream_topping1) { create(:ice_cream_topping, ice_cream: ice_cream, topping: topping1, quantity: 1) }
      let!(:ice_cream_topping2) { create(:ice_cream_topping, ice_cream: ice_cream, topping: topping2, quantity: 2) }

      it 'calculates price based on flavors, toppings, and quantities' do
        # (300 * 2) + (200 * 1) + (100 * 1) + (50 * 2) = 1000
        expect(ice_cream.price).to eq(1000)
      end
    end
  end
end 