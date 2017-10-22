require 'rails_helper'

RSpec.describe Room, type: :model do
  let!(:room) { build(:room) }
  let!(:user) { create(:user) }
  describe 'table association' do
    it { should have_many(:messages) }
  end
  describe 'scope' do
    it 'sort_by_message_created' do
      user.rooms << create_list(:room, 2, create_user_id: user.id)
      msg_first_room = create(:message, room: user.rooms.first, user: user, body:"1st message")
      msg_second_room = create(:message, room: user.rooms.second, user: user, body:"2nd message")
      rooms_expected = user.rooms.sort_by_message_created
      expect(rooms_expected.first.id).to eq(user.rooms.second.id)
    end
  end
  describe 'valid room model' do
    it "is valid" do
      room.save
      expect(room).to be_valid
    end
  end
  describe 'invalid room model' do
    it "is invalid when create_user_id is blank" do
      room.create_user_id = nil
      room.valid?
      expect(room.errors[:create_user_id]).to include("can't be blank")
    end
  end
end
