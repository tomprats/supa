class CreateFields < ActiveRecord::Migration
  def change
    create_table :fields do |t|
      t.string :name
      t.string :location

      t.timestamps
    end

    add_column :games, :datetime, :datetime
    add_column :games, :field_id, :integer
    add_column :games, :name, :string
  end
end
