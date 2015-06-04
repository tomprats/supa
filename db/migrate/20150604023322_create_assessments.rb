class CreateAssessments < ActiveRecord::Migration
  def change
    create_table :assessments do |t|
      t.integer :user_id
      t.string :deck_id
      t.string :uid
      t.string :blend_name
    end
  end
end
