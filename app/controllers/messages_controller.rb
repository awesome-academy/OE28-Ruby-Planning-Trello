class MessagesController < ApplicationController
  before_action :find_board, only: :create

  def new
    @receiver = User.find params[:user_id]
    @messages = Message.by_user_id(current_user.id, params[:user_id])
                       .by_board(params[:board_id])
                       .order_created
    respond_to :js
  end

  def create
    messages_params = message_params.merge receiver_id: params[:receiver_id],
                                           board_id: params[:board_id]
    @user = User.find params[:receiver_id]
    @message = current_user.receive_messages
                           .build messages_params

    @message.save!
    ActionCable.server.broadcast "chat_channel_#{@board.id}",
                                 content: {chat_html: chat_html}
  end

  private

  def chat_html
    BoardsController.render(
      partial: "boards/message",
      locals: {message: @message, current_user: @user},
      formats: [:html]
    )
  end

  def find_board
    @board = Board.find params[:board_id]
  end

  def message_params
    params.require(:message).permit Message::PERMIT_ATTRIBUTES
  end
end
