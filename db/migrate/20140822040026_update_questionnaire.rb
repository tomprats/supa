class UpdateQuestionnaire < ActiveRecord::Migration
  def up
    remove_column :questionnaires, :roles
    remove_column :questionnaires, :availability
    add_column :questionnaires, :handler, :boolean
    add_column :questionnaires, :cutter, :boolean
    add_column :questionnaires, :league_id, :integer
    change_column :questionnaires, :cocaptain, :boolean, default: false

    create_table :meetings do |t|
      t.datetime :datetime
      t.boolean :available, default: false
      t.integer :questionnaire_id

      t.timestamps
    end
  end

  def down
    add_column :questionnaires, :roles, :string
    add_column :questionnaires, :availability, :string
    remove_column :questionnaires, :handler
    remove_column :questionnaires, :cutter
    remove_column :questionnaires, :league_id

    drop_table :meetings
  end
end
