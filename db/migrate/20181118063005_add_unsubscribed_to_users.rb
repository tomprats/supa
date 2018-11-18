class AddUnsubscribedToUsers < ActiveRecord::Migration[5.2]
  def change
    add_column :users, :unsubscribed, :boolean, default: false
  end
end
