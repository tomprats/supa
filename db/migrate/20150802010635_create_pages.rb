class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :name
      t.string :path
      t.text :text
      t.integer :creator_id
      t.integer :importance, default: 0

      t.timestamps
    end
  end
end
