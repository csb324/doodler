require 'rails_helper'

feature 'Guest creates an account' do
  scenario 'successfully' do

    visit root_path
    click_link 'Sign up'
    fill_in 'Email', with: Faker::Internet.email
    @password = Faker::Lorem.words(3).join
    fill_in 'Password', with: @password
    fill_in 'Confirm Password', with: @password

    click_link 'Sign up'

    expect(page).to have_content "welcome"
  end

end
