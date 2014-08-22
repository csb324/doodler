require 'rails_helper'

feature 'User sees comments', :js do

  background do
    @user = create(:user)
    @userTwo = create(:user, name: "Bob")
    @mission = create(:mission)
    @doodle = create(:doodle, user: @userTwo, mission: @mission)
    @comment = create(:comment, user: @userTwo, doodle: @doodle, body: "Hey")
  end

  scenario "when they view a doodle with comments" do

    visit root_path
    click_link @mission.name
    click_link "by Bob"

    expect(page).to have_content "Hey"

  end

  scenario "but cannot comment if they are not signed in" do
    visit root_path
    click_link @mission.name
    click_link "by Bob"

    expect(page).to_not have_button "add comment"
  end

  scenario "can see comment form if they are signed in" do
    sign_in_as(@user)
    visit root_path
    click_link @mission.name
    click_link "by Bob"

    expect(page).to have_button "add comment"
  end

  scenario "can add a comment" do
    sign_in_as(@user)
    visit root_path
    click_link @mission.name
    click_link "by Bob"

    fill_in "comment-input", with: "my comment"
    click_button "add comment"

    expect(page).to have_content "my comment"
  end

  scenario "cannot add an empty comment" do
    sign_in_as(@user)
    visit root_path
    click_link @mission.name
    click_link "by Bob"

    fill_in "comment-input", with: ""
    click_button "add comment"

    expect(page).to_not have_content "You"
  end

end
