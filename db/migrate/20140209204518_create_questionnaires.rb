class CreateQuestionnaires < ActiveRecord::Migration
  def change
    create_table :questionnaires do |t|
      t.integer :user_id
      t.string :handling
      t.string :cutting
      t.string :defense
      t.string :fitness
      t.string :injuries
      t.string :height
      t.string :teams
      t.boolean :cocaptain
      t.string :roles

      t.timestamps
    end
  end
end
