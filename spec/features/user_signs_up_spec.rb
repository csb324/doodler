require 'rails_helper'

feature 'Guest creates an account' do
  scenario 'successfully' do

    visit root_path
    click_link 'Sign up'
    fill_in 'Email', with: Faker::Internet.email
    @password = Faker::Lorem.words(5).join
    fill_in 'Password', with: @password
    fill_in 'Password confirmation', with: @password

    click_button 'Sign up'

    expect(page).to have_content "welcome"
  end

end
