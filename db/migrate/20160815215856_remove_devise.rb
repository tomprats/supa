class RemoveDevise < ActiveRecord::Migration
  def change
    change_column :users, :email, :string, default: nil
    change_column :users, :encrypted_password, :string, default: nil, null: true
    rename_column :users, :encrypted_password, :password_digest
    remove_column :users, :reset_password_token
    remove_column :users, :reset_password_sent_at
    remove_column :users, :remember_created_at
    remove_column :users, :sign_in_count
    remove_column :users, :current_sign_in_at
    remove_column :users, :last_sign_in_at
    remove_column :users, :current_sign_in_ip
    remove_column :users, :last_sign_in_ip
  end
end
