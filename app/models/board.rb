class Board < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(name description status closed).freeze

  attr_accessor :user_id

  has_many :user_boards, class_name: UserBoard.name,
    foreign_key: :board_id,
    dependent: :destroy
  has_many :add_users, through: :user_boards, source: :user
  has_many :lists, dependent: :destroy
  has_many :notifications, dependent: :destroy
  has_many :labels, dependent: :destroy
  has_many :messages, dependent: :destroy

  validates :name, presence: true,
    length: {maximum: Settings.validate.max_board_name}

  validates :description, presence: true,
    length: {maximum: Settings.validate.max_board_description}

  scope :favorite, (lambda do |user_id|
    includes(:user_boards)
    .where(user_boards: {user_id: user_id,
                         starred: true})
  end)

  scope :nonfavorite, (lambda do |user_id|
    includes(:user_boards)
    .where(user_boards: {user_id: user_id,
                         starred: false})
  end)

  scope :opened, ->{where closed: false}
  scope :closed, ->{where closed: true}
  scope :order_created, ->{order created_at: :desc}
  scope :by_name, ->(result){where("name LIKE ?", "%#{result}%")}
  scope :by_status, ->(board_status){where status: board_status}

  ransack_alias :board_info, :name_or_description
  ransack_alias :user_info, :add_users_name_or_add_users_email

  ransacker :created_at do
    Arel.sql("date(boards.created_at)")
  end

  before_update :update_notification

  class << self
    def ransackable_attributes _auth_object = nil
      %w(name description board_info user_info created_at)
    end

    def ransortable_attributes _auth_object = nil
      %w(name description created_at)
    end
  end

  private

  def update_notification
    notification = notifications.build user_id: user_id
    notification.content = [
      I18n.t(".boards.create.noti_update"),
      I18n.t(".boards.create.board"),
      get_changed[:attribute_change],
      I18n.t(".boards.create.to"),
      get_changed[:value]
    ].join(" ")
    notification.save
  end

  def get_changed
    if attribute_changed? :name
      {
        attribute_change: "name",
        value: name_change[1]
      }
    elsif attribute_changed? :description
      {
        attribute_change: "description",
        value: description_change[1]
      }
    else
      {
        attribute_change: "status",
        value: "changed"
      }
    end
  end
end
