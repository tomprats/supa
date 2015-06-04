module Admin
  class UsersController < ApplicationController
    def index
      key = params[:key] || "last_name"
      @users = User.table_list(key)
      @registered_users = User.registered.table_list(key)
      @not_registered_users = User.not_registered.table_list(key)
    end
  end
end

