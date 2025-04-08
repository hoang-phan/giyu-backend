shared_examples 'product priced_item association' do |product_model, item_model|
  describe 'associations' do
    it { is_expected.to belong_to(product_model) }
    it { is_expected.to belong_to(item_model) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end
end 