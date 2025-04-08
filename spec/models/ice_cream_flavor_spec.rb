require 'rails_helper'

RSpec.describe IceCreamFlavor, type: :model do
  it_behaves_like 'product priced_item association', :ice_cream, :flavor
end
