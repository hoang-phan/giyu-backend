require 'rails_helper'

RSpec.describe Product, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:line_items).dependent(:restrict_with_error) }
  end

  describe 'attributes' do
    it 'aliases fixed_price as price' do
      product = Product.new(fixed_price: 100)
      expect(product.price).to eq(100)
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'fixed_price',
        'id',
        'id_value',
        'type',
        'updated_at'
      ]
      expect(Product.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the correct ransackable associations' do
      expect(Product.ransackable_associations).to match_array([ 'line_items' ])
    end
  end

  describe 'dependent restriction' do
    let!(:product) { create(:product) }

    context 'when associated line items exist' do
      let!(:line_item) { create(:line_item, product: product) }

      it 'prevents deletion when associated line items exist' do
        expect do
          expect(product.destroy).to be_falsey
          expect(product.errors.full_messages).to include "Cannot delete record because dependent line items exist"
        end.not_to change(Product, :count)
      end
    end

    context 'when no line items exist' do
      it 'allows deletion when no line items exist' do
        expect do
          expect(product.destroy).to be_truthy
        end.to change(Product, :count).by(-1)
      end
    end
  end
end
