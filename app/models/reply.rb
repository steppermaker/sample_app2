class Reply < ApplicationRecord
  belongs_to :destination, class_name: "Micropost"
  belongs_to :reply_micropost, class_name: "Micropost"
  validates :destination_id, presence: true
  validates :reply_micropost_id, presence: true
end
