class User < ActiveRecord::Base
  has_many :authentications, dependent: :destroy
  has_many :announcements
  has_and_belongs_to_many :teams
  has_many :tentative_players, foreign_key: :player_id, dependent: :destroy
  has_many :draft_players, foreign_key: :player_id, dependent: :destroy
  has_many :questionnaires, dependent: :destroy
  has_many :stats, class_name: "PlayerStat", foreign_key: :player_id, dependent: :destroy
  has_many :registrations
  has_many :payments, through: :registrations
  has_one :player_award

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable, :omniauthable,
         :omniauthable, :recoverable, :rememberable, :trackable,
         :validatable

  scope :super,    -> { where(admin: "super") }
  scope :standard, -> { where(admin: "standard") }
  scope :captain,  -> { where(admin: "captain") }
  scope :none,     -> { where(admin: "none") }

  def self.default_scope
    order(:last_name, :first_name)
  end

  def self.registered(league_id = nil)
    league_id ||= League.current.id
    joins(:registrations).where("registrations.league_id = ? AND registrations.registered = ?", league_id, true)
  end

  def self.not_registered
    where.not(id: registered.select(&:id))
  end

  def self.not_on_a_team
    league_id = League.current.id
    registered.select { |u| u.teams.empty? || !u.teams.collect(&:league_id).include?(league_id) }
  end

  def questionnaire_for(league_id)
    questionnaires.find_by(league_id: league_id)
  end

  def registration
    registrations.where(league_id: League.current.id).first
  end

  def not_registered?
    !registered?
  end

  def registered?
    registration && registration.registered?
  end

  def apply_omniauth(omni)
    authentications.build(
      provider:     omni['provider'],
      uid:          omni['uid'],
      token:        omni['credentials'].token,
      token_secret: omni['credentials'].secret
    )
  end

  def password_required?
    (authentications.empty? || !password.blank?) && super
  end

  def admin_collection
    {
      "None" => :none,
      "Standard" => :standard,
      "Super" => :super
    }
  end

  def is_super_admin?
    admin == "super"
  end

  def is_real_admin?
    admin == "super" || admin == "standard"
  end

  def is_captain?
    Team.where(captain_id: id).count > 0
  end

  def account_registered?
    phone_number &&
    (phone_number.length == 14) &&
    experience &&
    shirt_size &&
    name?
  end

  def drafted?(draft_id)
    !DraftedPlayer.where(player_id: id, draft_id: draft_id).empty?
  end

  def team(league_id = nil)
    if league_id
      teams.where(league_id: league_id).first
    else
      teams.where(league_id: League.current.id).first
    end
  end

  def on_a_team?
    !!team
  end

  def captains_team(league_id = nil)
    league_id ||= League.current.id
    Team.where(captain_id: id, league_id: league_id).first
  end

  def captains_teams
    Team.where(captain_id: id)
  end

  def drafts
    drafts = []
    captains_teams.each do |dteam|
      drafts += Draft.where(league_id: dteam.league_id)
    end
    drafts
  end

  def name?
    !first_name.empty? && !last_name.empty?
  end

  def name
    "#{first_name} #{last_name}"
  end

  def paid?
    league = League.current
    if registration
      payment = registration.payment
    else
      registrations.create(league_id: league.id)
    end
    payment ||= registration.create_payment
    return true if payment.paid?
    return false unless league.current_price.zero?
    payment.update_attributes(paid: true)
  end

  def games_played(league_id = nil)
    if league_id
      stats.map(&:team_stats).select { |ts| ts.league.try(:id) == league_id }.uniq.count
    else
      stats.map(&:team_stats).uniq.count
    end
  end

  def assists(league_id = nil)
    if league_id
      stats.select { |s| s.league.try(:id) == league_id }.reduce(0){|sum, s| sum + s.assists.to_i }
    else
      stats.reduce(0){|sum, s| sum + s.assists.to_i }
    end
  end

  def goals(league_id = nil)
    if league_id
      stats.select { |s| s.league.try(:id) == league_id }.reduce(0){|sum, s| sum + s.goals.to_i }
    else
      stats.reduce(0){|sum, s| sum + s.goals.to_i }
    end
  end

  def points(league_id = nil)
    assists(league_id) + goals(league_id)
  end

  def points_per_game(league_id = nil)
    if games_played(league_id).zero?
      0
    else
      (points(league_id)/games_played(league_id)).round(2)
    end
  end

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
