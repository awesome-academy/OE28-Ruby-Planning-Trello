class Message < ApplicationRecord
  PERMIT_ATTRIBUTES = %i(content).freeze

  belongs_to :sender, class_name: User.name, foreign_key: :sender_id
  belongs_to :receiver, class_name: User.name, foreign_key: :receiver_id
  belongs_to :board

  validates :sender_id, presence: true
  validates :receiver_id, presence: true

  scope :by_user_id, (lambda do |user_id, receiver_id|
    where(sender_id: user_id, receiver_id: receiver_id)
    .or where(sender: receiver_id, receiver_id: user_id)
  end)

  scope :by_board, ->(board_id){where board_id: board_id}

  scope :order_created, ->{order created_at: :asc}
end
