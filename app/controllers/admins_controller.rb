class AdminsController < ApplicationController
  before_filter :check_admin_level

  def super
    @super = User.super
    @standard = User.standard
    @captain = User.captain
    @none = User.none

    @team = Team.new
    @teams = Team.all
    @captains = @teams.collect { |t| User.find(t.captain) }
  end

  def standard
    @team = Team.new

    @teams = Team.all
    @current_teams = Team.active
    @inactive_teams = Team.inactive

    @captains = @teams.collect { |t| User.find(t.captain) }
    @current_captains = @current_teams.collect { |t| User.find(t.captain) }
    @inactive_captains = @inactive_teams.collect { |t| User.find(t.captain) }

    @users = User.all
    @active_users = User.active
    @inactive_users = User.inactive
  end

  def captain
    @current_team = Team.active.where(:captain => current_user.id).first
    @teams = Team.where(:captain => current_user.id)
  end

  private
  def check_admin_level
    case action_name
    when "super"
      if current_user.admin != "super"
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "standard"
      if current_user.admin == "none"
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    when "captain"
      if !current_user.is_captain?
        redirect_to profile_path, :notice => "You are not authorized to be there!"
      end
    end
  end
end

