class AddFieldsToUsers < ActiveRecord::Migration
  def change
    add_column :users, :first_name, :string
    add_column :users, :last_name, :string
    add_column :users, :phone_number, :string
    add_column :users, :experience, :string
    add_column :users, :birthday, :date
    add_column :users, :gender, :string
    add_column :users, :shirt_size, :string
    add_column :users, :admin, :string, :default => "none"
  end
end
