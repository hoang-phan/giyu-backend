require 'rails_helper'

RSpec.describe Order, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:line_items).dependent(:destroy) }
    it { is_expected.to accept_nested_attributes_for(:line_items).allow_destroy(true) }
  end

  describe 'state machine' do
    it 'has initial state of ordering' do
      expect(create(:order)).to be_ordering
    end

    it 'transitions from ordering to waiting_payment' do
      order = create(:order)
      expect { order.confirm! }.to change { order.status }.from('ordering').to('waiting_payment')
    end

    it 'transitions from waiting_payment to queueing' do
      order = create(:order, status: :waiting_payment)
      expect { order.queue! }.to change { order.status }.from('waiting_payment').to('queueing')
    end

    it 'transitions from queueing to producing' do
      order = create(:order, status: :queueing)
      expect { order.start_production! }.to change { order.status }.from('queueing').to('producing')
    end

    it 'transitions from producing to delivering' do
      order = create(:order, status: :producing)
      expect { order.finish_production! }.to change { order.status }.from('producing').to('delivering')
    end

    it 'transitions from delivering to completed' do
      order = create(:order, status: :delivering)
      expect { order.deliver! }.to change { order.status }.from('delivering').to('completed')
    end
  end

  describe 'callbacks' do
    describe 'before_save :calculate_total_amount' do
      let!(:order) { create(:order) }
      let!(:product1) { create(:ice_cream, fixed_price: 1000) }
      let!(:product2) { create(:ice_cream, fixed_price: 2000) }
      let!(:line_item1) { create(:line_item, order:, product: product1, quantity: 1, discount_percent: 10) }
      let!(:line_item2) { create(:line_item, order:, product: product2, quantity: 2, discount_percent: 20) }

      it 'calculates total amount from line items' do
        order.reload.save
        expect(order.reload.total_amount).to eq(1000 * 0.9 + 2000 * 2 * 0.8)
      end

      it 'updates total amount when line items change' do
        line_item1.update(quantity: 3)
        order.reload.save
        expect(order.reload.total_amount).to eq(1000 * 3 * 0.9 + 2000 * 2 * 0.8)
      end
    end
  end

  describe '.ransackable_attributes' do
    it 'returns the correct ransackable attributes' do
      expected_attributes = [
        'created_at',
        'id',
        'id_value',
        'status',
        'total_amount',
        'updated_at'
      ]
      expect(Order.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns the correct ransackable associations' do
      expect(Order.ransackable_associations).to match_array(['line_items'])
    end
  end
end 