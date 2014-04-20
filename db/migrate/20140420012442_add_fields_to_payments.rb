class AddFieldsToPayments < ActiveRecord::Migration
  def change
    add_column :payments, :setup_response, :text
    add_column :payments, :purchase_response, :text
    add_column :payments, :notify_response, :text
    add_column :payments, :transaction_id, :string
  end
end
