class AddSnakeToDrafts < ActiveRecord::Migration
  def change
    add_column :drafts, :snake, :boolean
  end
end
