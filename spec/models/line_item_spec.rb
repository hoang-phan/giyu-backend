require 'rails_helper'

RSpec.describe LineItem, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:order) }
    it { is_expected.to belong_to(:product) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than(0) }
    it { is_expected.to validate_numericality_of(:discount_percent).is_greater_than_or_equal_to(0).is_less_than_or_equal_to(100).allow_nil }
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'discount_percent',
        'id',
        'id_value',
        'order_id',
        'product_id',
        'quantity',
        'updated_at'
      ]
      expect(LineItem.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the correct ransackable associations' do
      expected_associations = [ 'order', 'product' ]
      expect(LineItem.ransackable_associations).to match_array(expected_associations)
    end
  end

  describe '#amount_with_fallback' do
    let(:line_item) { build(:line_item) }

    context 'when amount is present' do
      before { line_item.amount = 1000 }

      it 'returns the amount' do
        expect(line_item.amount_with_fallback).to eq(1000)
      end
    end

    context 'when amount is nil' do
      before { line_item.amount = nil }

      it 'returns the final_price' do
        expect(line_item.amount_with_fallback).to eq(line_item.final_price)
      end
    end
  end

  describe '#final_price' do
    let(:product) { create(:product, fixed_price: 1000) }
    let(:line_item) { build(:line_item, product: product, quantity: 2, discount_percent: 10) }

    it 'calculates the final price correctly' do
      # Base price: 1000 * 2 = 2000
      # After 10% discount: 2000 * 0.9 = 1800
      expect(line_item.final_price).to eq(1800)
    end

    context 'when discount_percent is nil' do
      let(:line_item) { build(:line_item, product: product, quantity: 2, discount_percent: nil) }

      it 'calculates the final price without discount' do
        expect(line_item.final_price).to eq(2000)
      end
    end
  end

  describe 'callbacks' do
    let(:product) { create(:product, fixed_price: 1000) }
    let(:line_item) { build(:line_item, product: product, quantity: 2, discount_percent: 10) }

    describe 'before_save :calculate_amount' do
      it 'calculates amount when quantity changes' do
        line_item.save
        expect(line_item.amount).to eq(1800)

        line_item.quantity = 3
        line_item.save
        expect(line_item.amount).to eq(2700)
      end

      it 'calculates amount when discount_percent changes' do
        line_item.save
        expect(line_item.amount).to eq(1800)

        line_item.discount_percent = 20
        line_item.save
        expect(line_item.amount).to eq(1600)
      end

      it 'calculates amount when product_id changes' do
        line_item.save
        expect(line_item.amount).to eq(1800)

        new_product = create(:product, fixed_price: 2000)
        line_item.product = new_product
        line_item.save
        expect(line_item.amount).to eq(3600)
      end

      it 'does not recalculate amount when unrelated attributes change' do
        line_item.save
        original_amount = line_item.amount

        line_item.touch
        expect(line_item.amount).to eq(original_amount)
      end
    end
  end
end
