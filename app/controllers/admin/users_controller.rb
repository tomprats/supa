module Admin
  class UsersController < ApplicationController
    def index
      key = params[:key] || "last_name"
      @users = User.all.order("#{key} ASC")
      @registered_users = User.registered
      @not_registered_users = User.not_registered
    end
  end
end

