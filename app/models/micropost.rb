class Micropost < ApplicationRecord
  belongs_to :user
  has_many :likes, dependent: :destroy
  has_many :like_users, through: :likes, source: :user
  has_many :destinations, class_name: "Reply",
                          foreign_key: "destination_id",
                          dependent: :destroy
  has_one :reply_microposts, class_name: "Reply", foreign_key: "reply_micropost_id",
                                                  dependent: :delete
  has_many :replies, ->{ reorder(created_at: :asc) },
                     through: :destinations, source: :reply_micropost
  has_one :reply_to, through: :reply_microposts, source: :destination

  default_scope -> { order(created_at: :desc) }
  scope :search_by_keyword, -> (keyword) {
    where("content LIKE :keyword",
          keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  mount_uploader :picture, PictureUploader
  validates :user_id , presence: true
  validates :content , presence: true, length: { maximum: 140 }
  validate  :picture_size

  def like(user)
    likes.create(user_id: user.id)
  end

  def unlike(user)
    likes.find_by(user_id: user.id).destroy
  end

  def like?(user)
    like_users.include?(user)
  end

  def add_reply(micropost)
    destinations.create(reply_micropost_id: micropost.id)
  end

  def has_reply?(micropost)
    replies.include?(micropost)
  end

  private
    def picture_size
      if picture.size > 5.megabytes
        error.add(:picture, "should be less than 5MB")
      end
    end
end
