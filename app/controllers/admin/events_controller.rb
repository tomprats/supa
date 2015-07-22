module Admin
  class EventsController < ApplicationController
    before_filter :check_admin_level

    def create
      params[:event][:datetime] = convert_to_datetime(params[:event].delete(:date), params[:event].delete(:time))
      @event = Event.create(event_params.merge!(creator_id: current_user.id))
      if @event.valid?
        redirect_to admin_events_path, notice: "Event was successfully created"
      else
        redirect_to :back, alert: "Event could not be created"
      end
    end

    def index
      @event = Event.new

      @events = Event.all
      @current_events = Event.where(league_id: League.current.id)
      @recent_events = @current_events.where(datetime: 1.week.ago..Time.now)
    end

    def edit
      @event = Event.find(params[:id])
    end

    def update
      params[:event][:datetime] = convert_to_datetime(params[:event].delete(:date), params[:event].delete(:time))
      if Event.find(params[:id]).update_attributes(event_params)
        redirect_to admin_events_path, notice: "Event was successfully updated"
      else
        redirect_to :back, alert: "Event could not be updated"
      end
    end

    def destroy
      event = Event.find(params[:id])
      if !event.game && event.destroy
        redirect_to admin_events_path, notice: "Event was successfully destroyed"
      else
        redirect_to :back, alert: "Event could not be destroyed"
      end
    end

    private
    def event_params
      params.require(:event).permit(
        :title,
        :text,
        :field_id,
        :league_id,
        :creator_id,
        :datetime
      )
    end

    def convert_to_datetime(date, time)
      DateTime.strptime("#{date} #{time} EDT", "%m/%d/%Y %I:%M %p %Z") if !date.blank? && !time.blank?
    end

    def check_admin_level
      unless current_user.is_real_admin?
        redirect_to profile_path, notice: "You are not authorized to be there!"
      end
    end
  end
end
