module API
  module Entities
    class User < Grape::Entity
      expose :name
      expose :email
      expose :admin
    end
  end
end
