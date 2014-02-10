class AddFieldsToQuestionnaire < ActiveRecord::Migration
  def change
    add_column :questionnaires, :availability, :string
    add_column :questionnaires, :comments, :string
  end

  def up
    remove_column :users, :active
  end

  def down
    add_column :users, :active, :boolean
  end
end
