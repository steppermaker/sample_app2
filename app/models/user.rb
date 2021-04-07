class User < ApplicationRecord
  has_many :microposts, dependent: :destroy
  has_many :likes,      dependent: :destroy
  has_many :entries,    dependent: :destroy
  has_many :active_relationships,  class_name:  "Relationship",
                                   foreign_key: "follower_id",
                                   dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship",
                                   foreign_key: "followed_id",
                                   dependent:   :destroy
  has_many :sent_messages,         class_name:  "Message",
                                   foreign_key: "user_id",
                                   dependent:   :destroy
  has_many :received_messages,     class_name:  "Message",
                                   foreign_key: "addressee_user_id",
                                   dependent:   :destroy
  has_many :following, through: :active_relationships,  source: :followed
  has_many :followers, through: :passive_relationships, source: :follower
  has_many :likes_microposts, through: :likes, source: :micropost
  scope :search_by_keyword, -> (keyword) {
    where("name Like :keyword",
          keyword: "%#{sanitize_sql_like(keyword)}%") if keyword.present?
  }
  attr_accessor :remember_token, :activation_token, :reset_token
  before_save   :downcase_email
  before_save   :downcase_unique_name
  before_create :create_activation_digest
  validates :name,  presence: true , length: { maximum: 50 }
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true , length: { maximum: 255 },
                    format: { with: VALID_EMAIL_REGEX },
                    uniqueness: { case_sensitive: false }
  has_secure_password
  validates :password, presence: true, length: { minimum: 6 }
  VALID_UNIQUE_NAME_REGEX = /\A[a-z0-9_]+\z/i
  validates :unique_name, presence: true, length: { in: 5..15 },
                                          format: { with: VALID_UNIQUE_NAME_REGEX},
                                          uniqueness: { case_sensitive: false }

  def self.digest(string)
    cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                  BCrypt::Engine.cost
    BCrypt::Password.create(string, cost: cost)
  end

  def self.new_token
    SecureRandom.urlsafe_base64
  end

  def remember
    self.remember_token = User.new_token
    update_attribute(:remember_digest, User.digest(remember_token))
  end

  def authenticated?(attribute, token)
    digest = send("#{attribute}_digest")
    return false if digest.nil?
    BCrypt::Password.new(digest).is_password?(token)
  end

  def forget
    update_attribute(:remember_digest, nil)
  end

  def activate
    update_columns(activated: true, activated_at: Time.zone.now)
  end

  def send_activation_email
    UserMailer.account_activation(self).deliver_now
  end

  def create_reset_digest
    self.reset_token = User.new_token
    update_columns(reset_digest: User.digest(reset_token), reset_sent_at: Time.zone.now)
  end

  def send_password_reset_email
    UserMailer.password_reset(self).deliver_now
  end

  def password_reset_expired?
    reset_sent_at < 2.hours.ago
  end

  def feed
    following_ids = "SELECT followed_id FROM relationships
                     WHERE follower_id = :user_id"
    Micropost.where("user_id IN (#{following_ids})
                     OR user_id = :user_id", user_id: id).includes(:user)
  end

  def follow(other_user)
    following << other_user
  end

  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  def following?(other_user)
    following.include?(other_user)
  end


  def mutual_follow?(user)
    following?(user) && user.following?(self)
  end

  def unread_messages_count
    received_messages.where("read = ?", false).count
  end

  def unread_messages
    received_messages.where("read = ?", false)
  end

  def destroy_rooms
    entries.each do |entry|
      Room.find(entry.room_id).destroy
    end
  end

  private

    def downcase_email
      self.email.downcase!
    end

    def create_activation_digest
      self.activation_token  = User.new_token
      self.activation_digest = User.digest(activation_token)
    end

    def downcase_unique_name
      self.unique_name.downcase!
    end
end
