require 'rails_helper'

RSpec.describe 'Flavors Admin', type: :system, js: true do
  let!(:admin) { create(:admin_user) }

  before do
    driven_by(:selenium_headless)
    sign_in_as_admin(admin)
  end

  describe 'flavors management' do
    it 'allows creating a new flavor' do
      visit admin_flavors_path
      click_link 'New Flavor'
      
      fill_in 'Name', with: 'Vanilla'
      fill_in 'Unit price', with: '599'
      click_button 'Create Flavor'
      
      expect(page).to have_content('Flavor was successfully created')
      expect(page).to have_content('Vanilla')
      expect(page).to have_content('599đ')
    end

    it 'allows editing an existing flavor' do
      flavor = create(:flavor, name: 'Chocolate', unit_price: 699)
      visit admin_flavors_path
      
      find("a[href='#{edit_admin_flavor_path(flavor)}']").click
      fill_in 'Name', with: 'Dark Chocolate'
      fill_in 'Unit price', with: '799'
      click_button 'Update Flavor'
      
      expect(page).to have_content('Flavor was successfully updated')
      expect(page).to have_content('Dark Chocolate')
      expect(page).to have_content('799đ')
    end

    it 'allows deleting a flavor' do
      flavor = create(:flavor, name: 'Strawberry', unit_price: 5.99)
      visit admin_flavors_path
      
      accept_confirm do
        find("a[href='#{admin_flavor_path(flavor)}'][data-method='delete']").click
      end
      
      expect(page).to have_content('Flavor was successfully destroyed')
      expect(page).not_to have_content('Strawberry')
    end

    it 'displays flavors list with correct information' do
      flavor1 = create(:flavor, name: 'Vanilla', unit_price: 599)
      flavor2 = create(:flavor, name: 'Chocolate', unit_price: 699)
      
      visit admin_flavors_path
      
      expect(page).to have_content('Vanilla')
      expect(page).to have_content('599đ')
      expect(page).to have_content('Chocolate')
      expect(page).to have_content('699đ')
    end
  end

  describe 'filtering flavors' do
    before do
      create(:flavor, name: 'Vanilla', unit_price: 599)
      create(:flavor, name: 'Chocolate', unit_price: 699)
      create(:flavor, name: 'Strawberry', unit_price: 799)
      create(:flavor, name: 'Mint', unit_price: 899)
    end

    it 'filters flavors by name' do
      visit admin_flavors_path
      
      fill_in 'Name', with: 'Chocolate'
      click_button 'Filter'
      
      expect(page).to have_content('Chocolate')
      expect(page).not_to have_content('Vanilla')
      expect(page).not_to have_content('Strawberry')
      expect(page).not_to have_content('Mint')
    end

    it 'filters flavors by unit price' do
      visit admin_flavors_path
      
      within '#q_unit_price_input' do
        find(:option, text: 'Greater than').select_option
        fill_in 'q_unit_price', with: '700'
      end
      click_button 'Filter'
      
      expect(page).to have_content('Strawberry')
      expect(page).to have_content('Mint')
      expect(page).not_to have_content('Vanilla')
      expect(page).not_to have_content('Chocolate')
    end

    it 'filters flavors by creation date' do
      # Create a flavor with a specific creation date
      flavor = create(:flavor, name: 'Special Flavor', unit_price: 999)
      flavor.update_column(:created_at, 1.day.ago)
      
      visit admin_flavors_path
      
      fill_in 'q_created_at_gteq', with: 2.days.ago.strftime('%Y-%m-%d')
      fill_in 'q_created_at_lteq', with: Time.current.strftime('%Y-%m-%d')
      click_button 'Filter'
      
      expect(page).to have_content('Special Flavor')
    end

    it 'clears filters' do
      visit admin_flavors_path
      
      fill_in 'Name', with: 'Chocolate'
      click_button 'Filter'
      
      expect(page).to have_content('Chocolate')
      expect(page).not_to have_content('Vanilla')
      
      click_link 'Clear Filters'
      
      expect(page).to have_content('Chocolate')
      expect(page).to have_content('Vanilla')
      expect(page).to have_content('Strawberry')
      expect(page).to have_content('Mint')
    end
  end
end 