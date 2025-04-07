require 'rails_helper'

RSpec.describe Flavor, type: :model do
  describe 'associations' do
    it { is_expected.to have_many(:ice_cream_flavors).dependent(:destroy) }
  end

  it_behaves_like 'priced_item'
end 