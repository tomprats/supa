class CreateBaggages < ActiveRecord::Migration
  def change
    create_table :baggages do |t|
      t.integer :league_id
      t.boolean :approved
      t.integer :approver_id
      t.integer :partner1_id
      t.integer :partner2_id
      t.string :comment1
      t.string :comment2
    end
  end
end
