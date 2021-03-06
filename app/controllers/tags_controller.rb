class TagsController < ApplicationController
  before_action :load_board, :check_permission, except: %i(index show new)
  before_action :load_list, :check_list_in_board, only: :create
  before_action :load_tag, only: %i(edit update destroy)
  before_action :load_notifications, only: %i(create update destroy)

  authorize_resource

  def create
    @tag = @list.tags.build tag_params.merge(position: position)
    @tag.user_id = current_user.id
    if @tag.save
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def edit
    @attachment = Attachment.new
    respond_to :js
  end

  def update
    @tag.user_id = current_user.id
    if @tag.update tag_params
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  def destroy
    if @tag.destroy
      flash.now[:success] = t ".success"
    else
      flash.now[:danger] = t ".failed"
    end
    respond_to :js
  end

  private

  def tag_params
    params.require(:tag).permit Tag::TAG_PARAMS
  end

  def load_board
    @board = Board.find params[:board_id]
  end

  def load_list
    @list = List.find params[:list_id]
  end

  def check_list_in_board
    return if @board.lists.include? @list

    flash[:danger] = t ".list_not_in_board"
    redirect_to @board
  end

  def load_tag
    @tag = Tag.find params[:id]
  end

  def position
    lastpos = @list.tags.opened.last_position
    return lastpos + Settings.number.one if lastpos.present?

    Settings.number.zero
  end
end
