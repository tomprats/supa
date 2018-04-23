class CreateImages < ActiveRecord::Migration[5.2]
  def change
    create_table :images do |t|
      t.string :link, null: false
      t.string :src, null: false
      t.integer :creator_id, null: false
      t.integer :importance, default: 0

      t.timestamps
    end
  end
end
