class Room < ApplicationRecord
  has_many :messages, dependent: :destroy
  has_many :entries,  dependent: :destroy

  def talking_user(current_user)
    entries.each do |entry|
      if entry.user != current_user
        return entry.user
      end
    end
    return current_user
  end

  def toggle_read(user)
    unread_messages = self.messages.where("addressee_user_id = ? and read = ?",
                                          user.id, false)
    unread_messages.each { |message| message.update_attribute(:read, true) }
  end
end
