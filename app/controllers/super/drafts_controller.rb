module Super
  class DraftsController < ApplicationController
    before_filter :check_admin_level

    def index
      @drafts = Draft.all
    end

    def create
      @draft = Draft.create(draft_params)
      redirect_to super_drafts_path, notice: "Draft successfully created."
    end

    def edit
      @draft = Draft.find(params[:id])
    end

    def update
      @draft.update(draft_params)
      redirect_to super_drafts_path, notice: "Draft successfully updated."
    end

    def destroy
      @draft = Draft.find(params[:id]).destroy
      redirect_to super_drafts_path, notice: "Draft successfully destroyed."
    end

    def activate
      draft = Draft.find(params[:id])
      draft.setup_players
      if draft.update_attributes(active: params[:active])
        redirect_to super_drafts_path, notice: "Draft has been updated"
      else
        redirect_to :back, alert: "Draft cannot be updated"
      end
    end

    def snake
      draft = Draft.find(params[:id])
      if draft.update_attributes(snake: params[:snake])
        redirect_to super_drafts_path, notice: "Draft has been updated"
      else
        redirect_to :back, alert: "Draft cannot be updated"
      end
    end

    def order
      draft = Draft.find(params[:id])
      order = params[:order].collect { |o| o.last.to_i }
      if order.length == order.uniq.length
        draft.update_attributes(order: order)
        redirect_to super_drafts_path, notice: "Draft order successfully updated."
      else
        redirect_to :back, alert: "Draft order could not be updated."
      end
    end

    private
    def check_admin_level
      unless current_user.is_super_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end

    def draft_params
      params.require(:draft).permit(:league_id, :active)
    end
  end
end