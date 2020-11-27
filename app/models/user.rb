class User < ApplicationRecord
  USER_PARAMS = %i(name avatar).freeze

  devise :database_authenticatable, :registerable, :confirmable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: %i(google_oauth2)

  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :user_id,
    dependent: :destroy
  has_many :join_boards, through: :user_boards, source: :board
  has_many :tag_users, class_name: TagUser.name,
    foreign_key: :user_id,
    dependent: :destroy
  has_many :join_tags, through: :tag_users, source: :tag
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :send_messages, class_name: Message.name,
    foreign_key: :receiver_id,
    dependent: :destroy
  has_many :receive_messages, class_name: Message.name,
    foreign_key: :sender_id,
    dependent: :destroy
  has_many :sender, through: :send_messages, source: :sender
  has_many :receiver, through: :receive_messages, source: :receiver

  mount_uploader :avatar, AvatarUploader

  delegate :url, :size, :filename, to: :avatar

  validates :name, presence: true,
    length: {maximum: Settings.user.name.length}

  scope :exclude_ids, ->(ids){where.not(id: ids)}

  def update_without_password params, *options
    if params[:password].blank? && params[:password_confirmation].blank?
      params.delete :password
      params.delete :password_confirmation
    end
    result = update params, *options
    clean_up_passwords
    result
  end

  def join_board board, type
    check = type.to_i.eql? Settings.data.confirm
    join_boards << board
    board.user_boards.first.update_attribute(:starred, true) if check
    board.user_boards.first.update_attribute(:role_id, :leader)
  end

  def is_leader? board
    user_boards.user_role(id, board.id).leader?
  end

  class << self
    def from_omniauth auth
      where(email: auth.info.email).first_or_create do |user|
        user.email = auth.info.email
        user.password = Devise.friendly_token[0, 20]
        user.name = auth.info.name
        user.skip_confirmation!
      end
    end
  end
end
