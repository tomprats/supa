class CreateTokens < ActiveRecord::Migration
  def change
    enable_extension "uuid-ossp"

    create_table :tokens do |t|
      t.integer :user_id, index: true,             null: false
      t.uuid :uuid, default: "uuid_generate_v4()", null: false

      t.timestamps null: false
    end
  end
end
