class AddBoardToNotifications < ActiveRecord::Migration[6.0]
  def change
    add_reference :notifications, :board, null: false, foreign_key: true
  end
end
