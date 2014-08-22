class AddToLeagues < ActiveRecord::Migration
  def change
    add_column :leagues, :current, :boolean, default: false
    add_column :leagues, :state, :string, default: "None"
    remove_column :drafts, :active
    remove_column :leagues, :active

    add_index :leagues, :current
  end
end
