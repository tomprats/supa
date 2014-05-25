class AddLateDraftFields < ActiveRecord::Migration
  def change
    add_column :leagues, :late_price, :decimal, default: 0
  end
end
