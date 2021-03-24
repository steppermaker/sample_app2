class Message < ApplicationRecord
  belongs_to :user,           class_name: "User"
  belongs_to :addressee_user, class_name: "User"
  belongs_to :room
  validates  :content, presence: true, length: { maximum: 140 }
end
