class AttachmentsController < ApplicationController
  before_action :logged_in_user, :load_data,
                :check_permission, only: :create
  def create
    @attachment = @tag.attachments.build attachment_params
    if @attachment.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def attachment_params
    params.require(:attachment).permit Attachment::ATTACHMENT_PARAMS
  end

  def load_data
    @board = Board.find params[:board_id]
    @tag = Tag.find params[:tag_id]
  end

  def check_permission
    permission = current_user.user_boards.find_by board_id: @board.id
    if permission
      return if permission.leader? || permission.member?

      flash[:danger] = t ".permission_denied"
      redirect_to @board
    else
      flash[:danger] = t ".user_not_in_board"
      redirect_to root_url
    end
  end
end
