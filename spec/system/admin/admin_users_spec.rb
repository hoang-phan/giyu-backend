require 'rails_helper'

RSpec.describe 'Admin Users Admin', type: :system, js: true do
  let!(:admin) { create(:admin_user) }

  before do
    driven_by(:selenium_headless)
    sign_in_as_admin(admin)
  end

  describe 'admin users management' do
    it 'allows creating a new admin user' do
      visit admin_admin_users_path
      click_link 'New Admin User'

      fill_in 'Email', with: 'newadmin@example.com'
      fill_in 'Password*', with: 'password123'
      fill_in 'Password confirmation', with: 'password123'
      click_button 'Create Admin user'

      expect(page).to have_content('Admin user was successfully created')
      expect(page).to have_content('newadmin@example.com')
    end

    it 'allows editing an existing admin user' do
      admin_user = create(:admin_user, email: 'oldemail@example.com')
      visit admin_admin_users_path

      find("a[href='#{edit_admin_admin_user_path(admin_user)}']").click
      fill_in 'Email', with: 'newemail@example.com'
      fill_in 'Password*', with: 'newpassword123'
      fill_in 'Password confirmation', with: 'newpassword123'
      click_button 'Update Admin user'

      expect(page).to have_content('Admin user was successfully updated')
      expect(page).to have_content('newemail@example.com')
    end

    it 'allows deleting an admin user' do
      admin_user = create(:admin_user, email: 'todelete@example.com')
      visit admin_admin_users_path

      accept_confirm do
        find("a[href='#{admin_admin_user_path(admin_user)}'][data-method='delete']").click
      end

      expect(page).to have_content('Admin user was successfully destroyed')
      expect(page).not_to have_content('todelete@example.com')
    end

    it 'displays admin users list with correct information' do
      admin_user1 = create(:admin_user, email: 'admin1@example.com')
      admin_user2 = create(:admin_user, email: 'admin2@example.com')

      visit admin_admin_users_path

      expect(page).to have_content('admin1@example.com')
      expect(page).to have_content('admin2@example.com')
    end
  end

  describe 'filtering admin users' do
    before do
      create(:admin_user, email: 'admin1@example.com')
      create(:admin_user, email: 'admin2@example.com')
      create(:admin_user, email: 'admin3@example.com')
      create(:admin_user, email: 'admin4@example.com')
    end

    it 'filters admin users by email' do
      visit admin_admin_users_path

      fill_in 'Email', with: 'admin2'
      click_button 'Filter'

      expect(page).to have_content('admin2@example.com')
      expect(page).not_to have_content('admin1@example.com')
      expect(page).not_to have_content('admin3@example.com')
      expect(page).not_to have_content('admin4@example.com')
    end

    it 'filters admin users by creation date' do
      # Create an admin user with a specific creation date
      admin_user = create(:admin_user, email: 'special@example.com')
      admin_user.update_column(:created_at, 1.day.ago)

      visit admin_admin_users_path

      fill_in 'q_created_at_gteq', with: 2.days.ago.strftime('%Y-%m-%d')
      fill_in 'q_created_at_lteq', with: Time.current.strftime('%Y-%m-%d')
      click_button 'Filter'

      expect(page).to have_content('special@example.com')
    end

    it 'clears filters' do
      visit admin_admin_users_path

      fill_in 'Email', with: 'admin2'
      click_button 'Filter'

      expect(page).to have_content('admin2@example.com')
      expect(page).not_to have_content('admin1@example.com')

      click_link 'Clear Filters'

      expect(page).to have_content('admin1@example.com')
      expect(page).to have_content('admin2@example.com')
      expect(page).to have_content('admin3@example.com')
      expect(page).to have_content('admin4@example.com')
    end
  end
end
