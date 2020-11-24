module API
  module V1
    class Boards < Grape::API
      prefix "api"
      version "v1", using: :path
      format :json
      include API::V1::Defaults

      before do
        authenticate_user!
      end

      resource :boards do
        desc "Return all boards"
        get "", root: :boards do
          present Board.all
        end

        desc "Return a board"
        params do
          requires :id, type: String, desc: "ID of the board"
        end
        get ":id", root: "board" do
          present Board.find params[:id]
        end

        desc "Create a board"
        params do
          requires :name, type: String, desc: "Name of the board"
          requires :description, type: String, desc: "Description of the board"
          requires :status, type: Boolean, desc: "Status of the board"
        end
        post do
          board = Board.new name: params[:name],
                            description: params[:description],
                            status: params[:status]
          present board if board.save!
        end
      end

      resource :boards do
        desc "Update a board"
        params do
          requires :id, type: String, desc: "ID of the board"
        end
        patch ":id" do
          board = Board.find params[:id]
          board_params = {
            name: params[:name].presence || board.name,
            description: params[:description].presence || board.description,
            status: params[:status].presence || board.status,
            closed: params[:closed].presence || board.closed
          }
          board.user_id = @current_user.id
          present board if board.update! board_params
        end

        desc "Delete a board"
        params do
          requires :id, type: String, desc: "ID of the board"
        end
        delete ":id" do
          board = Board.find params[:id]
          present Board.all if board.destroy
        end
      end
    end
  end
end
