module Super
  class EmailsController < ApplicationController
    before_action :check_admin_level

    def index
      @emails = Email.all
    end

    def create
      @email = Email.new(email_params.merge!(owner_id: current_user.id))

      if @email.save
        flash[:success] = "Email was successfully created"

        render json: {success: true}
      else
        render json: {success: false, error: @email.errors.full_messages.join(", ")}
      end
    end

    def show
      @email = Email.find(params[:id])
    end

    def edit
      @email = Email.find(params[:id])
    end

    def update
      @email = Email.find(params[:id])

      if @email.update_attributes(email_params.merge!(owner_id: current_user.id))
        flash[:success] = "Email was successfully updated"

        render json: {success: true}
      else
        render json: {success: false, error: @email.errors.full_messages.join(", ")}
      end
    end

    def destroy
      @email = Email.find(params[:id])

      if @email.destroy
        flash[:success] = "Email was successfully destroyed"

        render json: {success: true}
      else
        render json: {success: false, error: @email.errors.full_messages.join(", ")}
      end
    end

    def preview
      @email = Email.find(params[:id])

      if @email.can_preview? && @email.update(owner: current_user, previewed: true)
        EmailJob.perform_later(@email.id, preview: true)

        flash[:success] = "Preview is sending"

        render json: {success: true}
      else
        render json: {success: false, error: @email.errors.full_messages.join(", ")}
      end
    end

    def email
      @email = Email.find(params[:id])

      if @email.can_send? && @email.update(owner: current_user, sent: true)
        EmailJob.perform_later(@email.id, preview: false)

        flash[:success] = "Email is sending"

        render json: {success: true}
      else
        render json: {success: false, error: @email.errors.full_messages.join(", ")}
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, success: "You are not authorized to be there!"
      end
    end

    def email_params
      params.require(:email).permit(:body, :subject)
    end
  end
end
