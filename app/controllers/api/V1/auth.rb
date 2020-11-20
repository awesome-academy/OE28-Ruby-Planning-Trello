module API
  module V1
    class Auth < Grape::API
      prefix "api"
      version "v1", using: :path
      format :json

      helpers do
        def represent_user_with_token user
          present jwt_token: Authentication.encode(user_id: user.id)
        end
      end

      resources :auth do
        desc "Sign in"
        params do
          requires :email
          requires :password
        end

        post "/sign_in" do
          user = User.find_by email: params[:email]
          if user&.valid_password? params[:password]
            represent_user_with_token user
          else
            error!("Invalid email/password combination", 401)
          end
        end
      end
    end
  end
end
