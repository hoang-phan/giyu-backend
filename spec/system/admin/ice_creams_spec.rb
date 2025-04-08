require 'rails_helper'

RSpec.describe 'Ice Creams Admin', type: :system, js: true do
  let!(:admin) { create(:admin_user) }
  let!(:flavor1) { create(:flavor, name: 'Vanilla', unit_price: 599) }
  let!(:flavor2) { create(:flavor, name: 'Chocolate', unit_price: 699) }
  let!(:topping1) { create(:topping, name: 'Sprinkles', unit_price: 199) }
  let!(:topping2) { create(:topping, name: 'Whipped Cream', unit_price: 299) }

  before do
    driven_by(:selenium_headless)
    sign_in_as_admin(admin)
  end

  describe 'ice creams management' do
    it 'allows creating a new ice cream with fixed price' do
      visit admin_ice_creams_path
      click_link 'New Ice Cream'

      fill_in 'Name', with: 'Vanilla Delight'
      fill_in 'Fixed price', with: '1299'
      click_button 'Save Ice Cream'

      expect(page).to have_content('Ice cream was successfully created')
      expect(page).to have_content('Vanilla Delight')
      expect(page).to have_content('1 299đ')
    end

    it 'allows creating a new ice cream with flavors' do
      visit admin_ice_creams_path
      click_link 'New Ice Cream'

      fill_in 'Name', with: 'Mixed Flavors'

      # Add first flavor
      click_link 'Add Flavor'
      select 'Vanilla', from: 'ice_cream[ice_cream_flavors_attributes][0][flavor_id]'
      fill_in 'ice_cream[ice_cream_flavors_attributes][0][quantity]', with: '2'

      # Add second flavor
      click_link 'Add Flavor'
      select 'Chocolate', from: 'ice_cream[ice_cream_flavors_attributes][1][flavor_id]'
      fill_in 'ice_cream[ice_cream_flavors_attributes][1][quantity]', with: '1'

      click_button 'Save Ice Cream'

      expect(page).to have_content('Ice cream was successfully created')
      expect(page).to have_content('Mixed Flavors')

      # Check that flavors are displayed
      within '.panel', text: 'Flavors' do
        expect(page).to have_content('Vanilla')
        expect(page).to have_content('2')
        expect(page).to have_content('Chocolate')
        expect(page).to have_content('1')
      end

      # Check calculated price (2 * 599 + 1 * 699 = 1897)
      expect(page).to have_content('1 897đ')
    end

    it 'allows creating a new ice cream with toppings' do
      visit admin_ice_creams_path
      click_link 'New Ice Cream'

      fill_in 'Name', with: 'Topped Ice Cream'

      # Add first topping
      click_link 'Add Topping'
      select 'Sprinkles', from: 'ice_cream[ice_cream_toppings_attributes][0][topping_id]'
      fill_in 'ice_cream[ice_cream_toppings_attributes][0][quantity]', with: '2'

      # Add second topping
      click_link 'Add Topping'
      select 'Whipped Cream', from: 'ice_cream[ice_cream_toppings_attributes][1][topping_id]'
      fill_in 'ice_cream[ice_cream_toppings_attributes][1][quantity]', with: '1'

      click_button 'Save Ice Cream'

      expect(page).to have_content('Ice cream was successfully created')
      expect(page).to have_content('Topped Ice Cream')

      # Check that toppings are displayed
      within '.panel', text: 'Toppings' do
        expect(page).to have_content('Sprinkles')
        expect(page).to have_content('2')
        expect(page).to have_content('Whipped Cream')
        expect(page).to have_content('1')
      end

      # Check calculated price (2 * 199 + 1 * 299 = 697)
      expect(page).to have_content('697đ')
    end

    it 'allows creating a new ice cream with both flavors and toppings' do
      visit admin_ice_creams_path
      click_link 'New Ice Cream'

      fill_in 'Name', with: 'Complete Ice Cream'

      # Add flavor
      click_link 'Add Flavor'
      select 'Vanilla', from: 'ice_cream[ice_cream_flavors_attributes][0][flavor_id]'
      fill_in 'ice_cream[ice_cream_flavors_attributes][0][quantity]', with: '2'

      # Add topping
      click_link 'Add Topping'
      select 'Sprinkles', from: 'ice_cream[ice_cream_toppings_attributes][0][topping_id]'
      fill_in 'ice_cream[ice_cream_toppings_attributes][0][quantity]', with: '1'

      click_button 'Save Ice Cream'

      expect(page).to have_content('Ice cream was successfully created')
      expect(page).to have_content('Complete Ice Cream')

      # Check that flavors are displayed
      within '.panel', text: 'Flavors' do
        expect(page).to have_content('Vanilla')
        expect(page).to have_content('2')
      end

      # Check that toppings are displayed
      within '.panel', text: 'Toppings' do
        expect(page).to have_content('Sprinkles')
        expect(page).to have_content('1')
      end

      # Check calculated price (2 * 599 + 1 * 199 = 1397)
      expect(page).to have_content('1 397đ')
    end

    it 'allows editing an existing ice cream' do
      ice_cream = create(:ice_cream, name: 'Original Ice Cream', fixed_price: 999)
      create(:ice_cream_flavor, ice_cream: ice_cream, flavor: flavor1, quantity: 1)

      visit admin_ice_creams_path

      find("a[href='#{edit_admin_ice_cream_path(ice_cream)}']").click
      fill_in 'Name', with: 'Updated Ice Cream'
      fill_in 'Fixed price', with: '1499'
      click_button 'Save Ice Cream'

      expect(page).to have_content('Ice cream was successfully updated')
      expect(page).to have_content('Updated Ice Cream')
      expect(page).to have_content('1 499đ')
    end

    it 'allows deleting an ice cream' do
      ice_cream = create(:ice_cream, name: 'To Be Deleted', fixed_price: 999)
      visit admin_ice_creams_path

      accept_confirm do
        find("a[href='#{admin_ice_cream_path(ice_cream)}'][data-method='delete']").click
      end

      expect(page).to have_content('Ice cream was successfully destroyed')
      expect(page).not_to have_content('To Be Deleted')
    end

    it 'displays ice creams list with correct information' do
      ice_cream1 = create(:ice_cream, name: 'Vanilla Ice Cream', fixed_price: 999)
      ice_cream2 = create(:ice_cream, name: 'Chocolate Ice Cream', fixed_price: 1299)

      visit admin_ice_creams_path

      expect(page).to have_content('Vanilla Ice Cream')
      expect(page).to have_content('999đ')
      expect(page).to have_content('Chocolate Ice Cream')
      expect(page).to have_content('1 299đ')
    end
  end

  describe 'filtering ice creams' do
    before do
      create(:ice_cream, name: 'Vanilla Ice Cream', fixed_price: 999)
      create(:ice_cream, name: 'Chocolate Ice Cream', fixed_price: 1299)
      create(:ice_cream, name: 'Strawberry Ice Cream', fixed_price: 1499)
      create(:ice_cream, name: 'Mint Ice Cream', fixed_price: 1699)
    end

    it 'filters ice creams by fixed price' do
      visit admin_ice_creams_path

      within '#q_fixed_price_input' do
        find(:option, text: 'Greater than').select_option
        fill_in 'q_fixed_price', with: '1200'
      end
      click_button 'Filter'

      expect(page).to have_content('Chocolate Ice Cream')
      expect(page).to have_content('Strawberry Ice Cream')
      expect(page).to have_content('Mint Ice Cream')
      expect(page).not_to have_content('Vanilla Ice Cream')
    end

    it 'filters ice creams by creation date' do
      # Create an ice cream with a specific creation date
      ice_cream = create(:ice_cream, name: 'Special Ice Cream', fixed_price: 1999)
      ice_cream.update_column(:created_at, 1.day.ago)

      visit admin_ice_creams_path

      fill_in 'q_created_at_gteq', with: 2.days.ago.strftime('%Y-%m-%d')
      fill_in 'q_created_at_lteq', with: Time.current.strftime('%Y-%m-%d')
      click_button 'Filter'

      expect(page).to have_content('Special Ice Cream')
    end

    it 'clears filters' do
      visit admin_ice_creams_path

      within '#q_fixed_price_input' do
        find(:option, text: 'Greater than').select_option
        fill_in 'q_fixed_price', with: '1200'
      end
      click_button 'Filter'

      expect(page).to have_content('Chocolate Ice Cream')
      expect(page).not_to have_content('Vanilla Ice Cream')

      click_link 'Clear Filters'

      expect(page).to have_content('Chocolate Ice Cream')
      expect(page).to have_content('Vanilla Ice Cream')
      expect(page).to have_content('Strawberry Ice Cream')
      expect(page).to have_content('Mint Ice Cream')
    end
  end
end
