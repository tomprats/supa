module API
  class UsersController < ApplicationController
    def index
      @users = User.all.pluck(keys)
      render json: @users
    end

    def show
      @user = User.find(params[:id]).pluck(keys)
      render json: @user
    end

    private
    def keys
      [:id, :email, :first_name, :last_name]
    end
  end
end

