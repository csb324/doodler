require 'rails_helper'

feature 'User votes on a drawing', :js do

  background do
    @user = create(:user)
    @userTwo = create(:user)
    @mission = create(:mission)
    @doodle = create(:doodle, user: @userTwo, mission: @mission)
  end

  scenario 'unsuccessfully when not signed in' do
    @mission = create(:mission)
    visit root_path
    click_link @mission.name

    expect(page).to_not have_link 'Upvote'
    expect(page).to_not have_link 'Downvote'
  end

  scenario 'successfully' do

    sign_in_as(@user)
    visit root_path
    click_link @mission.name

    within('.single-doodle', text: @userTwo.email) do
      expect(page).to have_content '0'
      click_link 'Upvote'
      expect(page).to have_content '1'
      click_link 'Downvote'
      expect(page).to have_content '-1'
    end
  end

  scenario 'and can undo a vote' do
    sign_in_as(@user)
    visit root_path
    click_link @mission.name

    within('.single-doodle', text: @userTwo.email) do
      expect(page).to have_content '0'
      click_link 'Upvote'
      expect(page).to have_content '1'
      click_link 'Upvote'
      expect(page).to have_content '0'
    end
  end

end
