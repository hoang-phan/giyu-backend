shared_examples 'priced_item' do
  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:unit_price) }
    it { is_expected.to validate_numericality_of(:unit_price).is_greater_than_or_equal_to(0) }
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
      expect(described_class.ransackable_attributes).to match_array(expected_attributes)
    end
  end

  describe '.ransackable_associations' do
    it 'returns an empty array' do
      expect(described_class.ransackable_associations).to be_empty
    end
  end
end