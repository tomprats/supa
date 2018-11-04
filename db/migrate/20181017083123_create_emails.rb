class CreateEmails < ActiveRecord::Migration[5.2]
  def change
    create_table :emails do |t|
      t.references :owner, null: false
      t.string :body, null: false
      t.string :subject, null: false
      t.boolean :sent, default: false, null: false
      t.boolean :previewed, default: false, null: false

      t.timestamps
    end
  end
end
