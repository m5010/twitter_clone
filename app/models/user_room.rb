class UserRoom < ApplicationRecord
  belongs_to :user
  belongs_to :room, inverse_of: :user_rooms
  validates :user_id, presence: true
  validates :room, presence: true, uniqueness: { scope: :user_id }

  def mark_read_message(message)
    self.update_attributes(latest_read_message_id: message.id)
  end

  def delete_history
    update_attributes(available_flag: false, last_history_deleted: DateTime.now)
  end

  def datetime_history_deleted
    self.last_history_deleted.nil? ? self.created_at : self.last_history_deleted
  end

  def my_last_read_msg_id(room)
    msg_id = self.latest_read_message_id
    if msg_id == 0 && room.messages.count != 0
      room.messages.order(id: :asc).first.id
    else
      msg_id
    end
  end
end
