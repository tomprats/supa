class CreatePayments < ActiveRecord::Migration
  def change
    create_table :registrations do |t|
      t.boolean :registered, default: false
      t.integer :user_id
      t.integer :league_id

      t.timestamps
    end

    create_table :payments do |t|
      t.boolean :paid, default: false
      t.integer :registration_id
      t.string  :payer_id
      t.string  :token

      t.timestamps
    end

    create_table :leagues do |t|
      t.string  :season
      t.integer :year
      t.decimal :price, default: 0
      t.boolean :active, default: false

      t.timestamps
    end

    add_column :drafts, :league_id, :integer
    add_column :teams, :league_id, :integer
    add_column :games, :league_id, :integer

    remove_column :drafts, :season, :string
    remove_column :drafts, :year, :integer
    remove_column :teams, :season, :string
    remove_column :teams, :year, :integer
    remove_column :users, :spring_registered, :boolean
    remove_column :users, :active, :boolean
    remove_column :teams, :active, :boolean
  end
end
