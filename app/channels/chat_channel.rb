class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "chat_channel_#{params[:board_id]}"
  end

  def unsubscribed; end
end