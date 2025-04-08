require 'rails_helper'

RSpec.describe 'Orders Admin', type: :system, js: true do
  let!(:admin) { create(:admin_user) }
  let!(:product1) { create(:ice_cream, name: 'Vanilla Ice Cream', fixed_price: 1000) }
  let!(:product2) { create(:ice_cream, name: 'Chocolate Ice Cream', fixed_price: 2000) }

  before do
    driven_by(:selenium_headless)
    sign_in_as_admin(admin)
  end

  describe 'orders management' do
    it 'allows creating a new order with line items' do
      visit admin_orders_path
      click_link 'New Order'

      click_link 'Add Line Item'
      # Add first line item
      select 'Vanilla Ice Cream', from: 'order[line_items_attributes][0][product_id]'
      fill_in 'order[line_items_attributes][0][quantity]', with: '2'
      fill_in 'order[line_items_attributes][0][discount_percent]', with: '10'

      # Add second line item
      click_link 'Add Line Item'
      select 'Chocolate Ice Cream', from: 'order[line_items_attributes][1][product_id]'
      fill_in 'order[line_items_attributes][1][quantity]', with: '1'
      fill_in 'order[line_items_attributes][1][discount_percent]', with: '0'

      click_button 'Save Order'

      expect(page).to have_content('Order was successfully created')

      # Check that line items are displayed
      within '.panel', text: 'Line Items' do
        expect(page).to have_content('Vanilla Ice Cream')
        expect(page).to have_content('2')
        expect(page).to have_content('10.000%')
        expect(page).to have_content('Chocolate Ice Cream')
        expect(page).to have_content('1')
        expect(page).to have_content('0.000%')
      end
    end

    it 'allows editing an existing order' do
      order = create(:order, status: 'ordering')
      create(:line_item, order: order, product: product1, quantity: 1, discount_percent: 0)

      visit admin_orders_path
      find("a[href='#{edit_admin_order_path(order)}']").click

      # Update line item
      fill_in 'order[line_items_attributes][0][quantity]', with: '3'
      fill_in 'order[line_items_attributes][0][discount_percent]', with: '20'

      click_button 'Save Order'

      expect(page).to have_content('Order was successfully updated')

      within '.panel', text: 'Line Items' do
        expect(page).to have_content('3')
        expect(page).to have_content('20.000%')
      end
    end

    it 'allows removing line items from an order' do
      order = create(:order, status: 'ordering')
      create(:line_item, order: order, product: product1, quantity: 1, discount_percent: 0)

      visit admin_orders_path
      find("a[href='#{edit_admin_order_path(order)}']").click

      click_link 'Remove'
      click_button 'Save Order'

      expect(page).to have_content('Order was successfully updated')
      expect(page).not_to have_content('Vanilla Ice Cream')
    end

    it 'allows transitioning order status' do
      order = create(:order, status: 'ordering')
      visit admin_orders_path

      click_link 'Confirm'

      expect(page).to have_content('Order status updated to waiting_payment')
      expect(page).to have_content('waiting_payment')
    end

    it 'displays orders list with correct information' do
      order1 = create(:order, status: 'ordering')
      order2 = create(:order, status: 'waiting_payment')
      create(:line_item, order: order1, product: product1, quantity: 2, discount_percent: 10)
      create(:line_item, order: order2, product: product2, quantity: 1, discount_percent: 0)
      order1.reload.save
      order2.reload.save

      visit admin_orders_path

      within '#index_table_orders' do
        expect(page).to have_content('ordering')
        expect(page).to have_content('waiting_payment')
        expect(page).to have_content('1 800đ') # 2 * 1000 * 0.9
        expect(page).to have_content('2 000đ') # 1 * 2000
      end
    end
  end

  describe 'filtering orders' do
    before do
      create(:order, status: 'ordering', created_at: 1.day.ago)
      create(:order, status: 'waiting_payment', created_at: 2.days.ago)
      create(:order, status: 'completed', created_at: 3.days.ago)
    end

    it 'filters orders by status' do
      visit admin_orders_path

      select 'waiting_payment', from: 'q_status'
      click_button 'Filter'

      within '#index_table_orders' do
        expect(page).to have_content('waiting_payment')
        expect(page).not_to have_content('ordering')
        expect(page).not_to have_content('completed')
      end
    end

    it 'filters orders by creation date' do
      visit admin_orders_path

      fill_in 'q_created_at_gteq', with: 2.days.ago.strftime('%Y-%m-%d')
      fill_in 'q_created_at_lteq', with: Time.current.strftime('%Y-%m-%d')
      click_button 'Filter'

      within '#index_table_orders' do
        expect(page).to have_content('ordering')
        expect(page).to have_content('waiting_payment')
        expect(page).not_to have_content('completed')
      end
    end

    it 'clears filters' do
      visit admin_orders_path

      select 'waiting_payment', from: 'q_status'
      click_button 'Filter'

      within '#index_table_orders' do
        expect(page).to have_content('waiting_payment')
        expect(page).not_to have_content('ordering')
      end

      click_link 'Clear Filters'

      within '#index_table_orders' do
        expect(page).to have_content('ordering')
        expect(page).to have_content('waiting_payment')
        expect(page).to have_content('completed')
      end
    end
  end
end
