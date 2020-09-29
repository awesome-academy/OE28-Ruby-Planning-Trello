class ListsController < ApplicationController
  before_action :find_board
  before_action :find_list, only: %i(update change_position closed_list)

  def create
    @list = @board.lists.build list_params
    @list.position = if @board.lists.max_position.present?
                       @board.lists.max_position + Settings.data.confirm
                     else
                       Settings.data.notconfirm
                     end
    if @list.save
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  def update
    if @list.update list_params
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  def change_position
    old_position = @list.position
    new_position = params[:position].to_i
    if @list.update_attribute :position, params[:position]
      update_list_position old_position, new_position, @board, @list.id
      flash[:success] = t ".success"
    else
      flash[:danger] = t ".fail"
    end
    redirect_to @board
  end

  def closed_list
    position_remove = @list.position
    if @list.update closed: true, position: nil
      move_lists = @board.lists.greater position_remove
      List.decrease_position move_lists
      flash[:warning] = "closed"
    else
      flash[:danger] = "fail"
    end
    redirect_to @board
  end

  private

  def find_board
    @board = Board.find_by id: params[:board_id]
    return if @board

    flash[:danger] = t ".cant_find"
    redirect_to root_path
  end

  def find_list
    @list = List.find_by id: params[:list_id]
    return if @list

    flash[:danger] = t ".cant_find"
    redirect_to root_path
  end

  def update_list_position old_position, new_position, board, changed_list_id
    lists = board.lists
    if old_position < new_position
      move_lists = lists.greater(old_position)
                        .less(new_position + Settings.data.confirm)
                        .not_id(changed_list_id)
      List.decrease_position move_lists
    elsif old_position > new_position
      move_lists = lists.greater(new_position - Settings.data.confirm)
                        .less(old_position)
                        .not_id(changed_list_id)
      List.increase_position move_lists
    end
  end

  def list_params
    params.require(:list).permit List::PERMIT_ATTRIBUTES
  end
end
