module API
  module V1
    class Users < Grape::API
      resource :users do
        desc "Return list of users"
        get do
          policy_scope User
        end
      end
    end
  end
end
