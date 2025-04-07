require 'rails_helper'

RSpec.describe 'Toppings Admin', type: :system, js: true do
  let!(:admin) { create(:admin_user) }

  before do
    driven_by(:selenium_headless)
    sign_in_as_admin(admin)
  end

  describe 'toppings management' do
    it 'allows creating a new topping' do
      visit admin_toppings_path
      click_link 'New Topping'
      
      fill_in 'Name', with: 'Sprinkles'
      fill_in 'Unit price', with: '1000'
      click_button 'Create Topping'
      
      expect(page).to have_content('Topping was successfully created')
      expect(page).to have_content('Sprinkles')
      expect(page).to have_content('1 000đ')
    end

    it 'allows editing an existing topping' do
      topping = create(:topping, name: 'Wallnut', unit_price: 685)
      visit admin_toppings_path
      
      find("a[href='#{edit_admin_topping_path(topping)}']").click
      fill_in 'Name', with: 'Dark Wallnut'
      fill_in 'Unit price', with: '799'
      click_button 'Update Topping'
      
      expect(page).to have_content('Topping was successfully updated')
      expect(page).to have_content('Dark Wallnut')
      expect(page).to have_content('799đ')
    end

    it 'allows deleting a topping' do
      topping = create(:topping, name: 'Peanut', unit_price: 5.99)
      visit admin_toppings_path
      
      accept_confirm do
        find("a[href='#{admin_topping_path(topping)}'][data-method='delete']").click
      end
      
      expect(page).to have_content('Topping was successfully destroyed')
      expect(page).not_to have_content('Peanut')
    end

    it 'displays toppings list with correct information' do
      topping1 = create(:topping, name: 'Donut', unit_price: 599)
      topping2 = create(:topping, name: 'Wallnut', unit_price: 685)
      
      visit admin_toppings_path
      
      expect(page).to have_content('Donut')
      expect(page).to have_content('599đ')
      expect(page).to have_content('Wallnut')
      expect(page).to have_content('685đ')
    end
  end

  describe 'filtering toppings' do
    before do
      create(:topping, name: 'Donut', unit_price: 599)
      create(:topping, name: 'Wallnut', unit_price: 685)
      create(:topping, name: 'Peanut', unit_price: 799)
      create(:topping, name: 'Marshmallow', unit_price: 899)
    end

    it 'filters toppings by name' do
      visit admin_toppings_path
      
      fill_in 'Name', with: 'Wallnut'
      click_button 'Filter'
      
      expect(page).to have_content('Wallnut')
      expect(page).not_to have_content('Donut')
      expect(page).not_to have_content('Peanut')
      expect(page).not_to have_content('Marsh')
    end

    it 'filters toppings by unit price' do
      visit admin_toppings_path
      
      within '#q_unit_price_input' do
        find(:option, text: 'Greater than').select_option
        fill_in 'q_unit_price', with: '700'
      end
      click_button 'Filter'
      
      expect(page).to have_content('Peanut')
      expect(page).to have_content('Marsh')
      expect(page).not_to have_content('Donut')
      expect(page).not_to have_content('Wallnut')
    end

    it 'filters toppings by creation date' do
      # Create a topping with a specific creation date
      topping = create(:topping, name: 'Special Topping', unit_price: 999)
      topping.update_column(:created_at, 1.day.ago)
      
      visit admin_toppings_path
      
      fill_in 'q_created_at_gteq', with: 2.days.ago.strftime('%Y-%m-%d')
      fill_in 'q_created_at_lteq', with: Time.current.strftime('%Y-%m-%d')
      click_button 'Filter'
      
      expect(page).to have_content('Special Topping')
    end

    it 'clears filters' do
      visit admin_toppings_path
      
      fill_in 'Name', with: 'Wallnut'
      click_button 'Filter'
      
      expect(page).to have_content('Wallnut')
      expect(page).not_to have_content('Donut')
      
      click_link 'Clear Filters'
      
      expect(page).to have_content('Wallnut')
      expect(page).to have_content('Donut')
      expect(page).to have_content('Peanut')
      expect(page).to have_content('Marsh')
    end
  end
end 