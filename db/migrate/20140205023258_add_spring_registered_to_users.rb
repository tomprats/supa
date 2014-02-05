class AddSpringRegisteredToUsers < ActiveRecord::Migration
  def change
    add_column :users, :spring_registered, :boolean
  end
end
