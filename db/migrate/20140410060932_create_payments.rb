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

    # Convert drafts season/year to league
    Draft.all.each do |draft|
      league = League.where(season: draft.season, year: draft.year).first
      league ||= League.create(season: draft.season, year: draft.year)
      draft.update_attributes(league_id: league.id)
    end

    # Convert teams season/year to league
    Team.all.each do |team|
      league = League.where(season: team.season, year: team.year).first
      league ||= League.create(season: team.season, year: team.year)
      team.update_attributes(league_id: league.id)
    end

    # Convert games season/year to league
    Game.all.each do |game|
      team = game.team1
      league = League.where(season: team.season, year: team.year).first
      league ||= League.create(season: team.season, year: team.year)
      game.update_attributes(league_id: league.id)
    end

    # Convert spring registered to payment
    User.where(spring_registered: true).each do |user|
      registration = Registration.create(
        user_id: user.id,
        league_id: League.where(season: "Spring", year: 2014).first.id,
        registered: true
      )
      Payment.create(
        registration_id: registration.id,
        paid: true
      )
    end

    remove_column :drafts, :season, :string
    remove_column :drafts, :year, :integer
    remove_column :teams, :season, :string
    remove_column :teams, :year, :integer
    remove_column :users, :spring_registered, :boolean
    remove_column :users, :active, :boolean
    remove_column :teams, :active, :boolean
  end
end
