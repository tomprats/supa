class DraftsController < ApplicationController
  before_filter :check_admin_level

  def new
    @draft = Draft.new
  end

  def create
    @draft = Draft.create(draft_params)
    redirect_to :back, :notice => "Draft successfully created."
  end

  def show
    @draft = Draft.find(params[:id])
  end

  def index
    @drafts = []
    @teams = current_user.teams_captain_of
    @drafts = current_user.drafts
  end

  def edit
    @draft = Draft.find(params[:id])
  end

  def update
    @draft = Draft.find(params[:id])
    @draft.update(draft_params)
    redirect_to :back, :notice => "Draft successfully updated."
  end

  def destroy
    @draft = Draft.find(params[:id]).destroy
    redirect_to :back, :notice => "Draft successfully destroyed."
  end

  private
  def draft_params
    params.require(:draft).permit(:season,
                                  :year,
                                  :active)
  end

  def check_admin_level
    case action_name
    when "new", "create", "edit", "update", "destroy"
      if current_user.admin != "super"
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "show", "index"
      if !current_user.is_captain?
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end
