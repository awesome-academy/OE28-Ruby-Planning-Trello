module API
  module V1
    module Defaults
      extend ActiveSupport::Concern
      included do
        prefix "api"
        version "v1", using: :path
        format :json

        rescue_from ActiveRecord::RecordNotFound do |e|
          error_response(message: e.message, status: 404)
        end

        rescue_from :all do |e|
          raise e if Rails.env.development?

          error_response(message: e.message, status: 500)
        end

        helpers do
          def authenticate_user!
            token = request.headers["Jwt-Token"]
            user_id = Authentication.decode(token)["user_id"] if token
            @current_user = User.find user_id
            return if @current_user

            api_error!("You need to log in", "failure", 401, {})
          end
        end
      end
    end
  end
end
