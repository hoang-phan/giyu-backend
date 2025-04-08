require 'rails_helper'

RSpec.describe IceCreamTopping, type: :model do
  it_behaves_like 'product priced_item association', :ice_cream, :topping
end
