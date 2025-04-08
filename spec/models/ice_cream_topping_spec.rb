require 'rails_helper'

RSpec.describe IceCreamTopping, type: :model do
  describe 'associations' do
    it { is_expected.to belong_to(:ice_cream) }
    it { is_expected.to belong_to(:topping) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:quantity) }
    it { is_expected.to validate_numericality_of(:quantity).is_greater_than_or_equal_to(0) }
  end
end 