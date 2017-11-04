require 'rails_helper'

RSpec.feature 'Create room', type: :feature do
  given!(:bob) { create(:user, name: "Bob") }
  given!(:alice) { create(:user, name: "Alice") }
  given!(:carol) { create(:user, name: "Carol") }

  context "as logged in user" do
    scenario "display create message form" do
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      expect(page).to have_selector "h1", text: "Create Message"
      expect(page).to have_button "Next"
      expect(page).not_to have_field("Bob")
      expect(page).to have_field("Alice")
      expect(page).to have_field("Carol")
    end
    scenario "create message room successfully" do
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      # TODO: select user and submit then display room
    end
    scenario "display messages of room" do
      room_first = create(:room, create_user_id: bob.id,
                                  user_ids:[bob.id,alice.id])
      login_as(bob)
      visit root_path
      click_link "Message"
      # TODO: select room and display messages of room
    end
    scenario "cannot create room with no participants" do
      room_first = create(:room, create_user_id: bob.id,
                                  user_ids:[bob.id,alice.id])
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      # TODO: select no participant of room and redirect messages of room
    end
    scenario "cannot create room with dup participants combination" do
      room_first = create(:room, create_user_id: bob.id,
                                  user_ids:[bob.id,alice.id])
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      # TODO: select dup participant of room and redirect create room
    end
    scenario "rejoin the room of same participants after deletion of message history" do
      room_first = create(:room, create_user_id: bob.id,
                                  user_ids:[bob.id,alice.id])
      login_as(bob)
      visit root_path
      click_link "Message"
      click_link "Create Message"
      # TODO: select dup participant of room and redirect messages of room
    end
  end
  context "as not logged in user" do
    scenario "redirect to login page" do
      user = create(:user)
      visit root_path
      visit "/users/#{user.id}/rooms/new"
      expect(page).to have_content "Please log in."
    end
  end
end
