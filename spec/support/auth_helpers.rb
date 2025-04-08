module AuthHelpers
  def sign_in_as_admin(admin_user = nil)
    admin_user ||= create(:admin_user)
    visit new_admin_user_session_path
    fill_in 'Email', with: admin_user.email
    fill_in 'Password', with: admin_user.password
    click_button 'Sign In'
    admin_user
  end
end

RSpec.configure do |config|
  config.include AuthHelpers, type: :system
end