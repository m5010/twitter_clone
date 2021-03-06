require 'rails_helper'

RSpec.feature 'Display rooms', type: :feature do
  given!(:bob) { create(:user, name: "Bob") }
  given!(:alice) { create(:user, name: "Alice") }
  given!(:carol) { create(:user, name: "Carol") }
  given!(:room) { create(:room, create_user: bob, users:[bob,alice]) }
  context "as logged in user" do
    scenario "display only rooms where current user participates" do
      room_without_me = create(:room, create_user: alice, users:[alice,carol])
      msg_bob = create(:message, room: bob.rooms.first, user: bob, body:"1st_bob")
      msg_alice = create(:message, room: bob.rooms.first, user: alice, body:"1st_alice")
      msg_carol_without_me = create(:message, room: carol.rooms.first, user: carol, body:"1st_carol")
      login_as(bob)
      visit root_path
      click_link "Message"
      expect(page).to have_selector "h1", text: "Direct Messages"
      expect(page).to have_selector ".rooms-button", text: "Create Message"
      expect(page).to have_css(".rooms__item__avater")
      expect(page).to have_selector ".rooms__item__box__user", text: "Bob / Alice"
      expect(page).to have_selector ".rooms__item__box__msg", text: "1st_alice"
      expect(page).not_to have_selector ".rooms__item__box__user", text: "Alice / Carol"
      expect(page).not_to have_selector ".rooms__item__box__msg", text: "1st_carol"
    end
    scenario "change backgroud color of room with unread messages" do
      login_as(alice)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in "message[body]", with: '1st_alice'
      click_button "Post"
      click_link "Log out"
      login_as(bob)
      click_link "Message"
      expect(page).to have_selector ".rooms__item__box__user", text: "Bob / Alice"
      expect(page).to have_selector ".rooms__item__box__msg", text: "1st_alice"
      expect(page).to have_css(".rooms__item--unread")
    end
    scenario "do not change backgroud color of room with no unread messages", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in 'message[body]', with: 'new bob message.'
      click_button "Post"
      click_link "Message"
      expect(page).not_to have_css(".rooms__item--unread")
    end
    scenario "redisplay the room deleted after other user post a message", js: true do
      login_as(bob)
      click_link "Message"
      click_link "Bob / Alice"
      page.accept_confirm 'Are you sure?' do
        click_link "Delete messages history"
      end
      click_link "Log out"
      login_as(alice)
      click_link "Message"
      click_link "Bob / Alice"
      fill_in "message[body]", with: 'new alice message.'
      click_button "Post"
      click_link "Log out"
      login_as(bob)
      click_link "Message"
      expect(page).to have_selector ".rooms__item__box__user", text: "Bob / Alice"
      expect(page).to have_selector ".rooms__item__box__msg", text: "new alice message."
      expect(page).to have_css(".rooms__item--unread")
    end
  end
  context "as not logged in user" do
    scenario "redirect to login page" do
      user = create(:user)
      visit root_path
      expect(page).not_to have_content "Message"
      visit "/users/#{user.id}/rooms"
      expect(page).to have_content "Please log in."
    end
  end
end
