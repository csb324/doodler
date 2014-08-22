require 'rails_helper'

feature 'user signs in with facebook' do
  scenario 'successfully' do
    login_with_oauth
    visit root_path

    expect(page).to have_content("welcome")
  end
end
