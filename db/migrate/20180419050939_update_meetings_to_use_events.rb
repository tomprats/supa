class UpdateMeetingsToUseEvents < ActiveRecord::Migration[5.2]
  def change
    Meeting.delete_all

    add_column :meetings, :event_id, :integer, null: false
    remove_column :meetings, :datetime, :datetime
  end
end
