class User < ActiveRecord::Base
  has_many :authentications, dependent: :destroy
  has_many :announcements
  has_and_belongs_to_many :teams
  has_many :tentative_players, foreign_key: :player_id, dependent: :destroy
  has_many :questionnaires, dependent: :destroy
  has_many :stats, class_name: "PlayerStat", foreign_key: :player_id, dependent: :destroy
  has_many :registrations
  has_many :payments, through: :registrations
  has_many :player_awards
  has_many :assessments, dependent: :destroy

  devise :database_authenticatable, :registerable, :omniauthable,
         :omniauthable, :recoverable, :rememberable, :trackable,
         :validatable

  scope :super,    -> { where(admin: "super") }
  scope :standard, -> { where(admin: "standard") }
  scope :simple,   -> { where(admin: "none") }

  def self.tom
    find_by(email: "tprats108@gmail.com")
  end

  def self.default_scope
    order(:last_name, :first_name)
  end

  def self.table_list(key = nil)
    key.blank? ? tmp = self : tmp = order("#{key} ASC")
    tmp = tmp.includes(:assessments, :questionnaires)
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

  def self.exportable_attributes
    [
      ["first_name", "First Name"],
      ["last_name", "Last Name"],
      ["email", "Email"],
      ["phone_number", "Phone Number"]
    ]
  end

  def assessment
    unless a = assessments.to_a.first
      uid = Traitify.new.create_assessment.id
      a = assessments.create(uid: uid, deck_id: "core")
    end

    a
  end

  def player_award(league_id = League.current.id)
    player_awards.find_by(league_id: league_id)
  end

  def questionnaire
    questionnaires.find_by(league_id: League.current.id)
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

  def self.shirt_sizes
    [
      "Mens XSmall",
      "Mens Small",
      "Mens Medium",
      "Mens Large",
      "Mens XLarge",
      "Mens XXLarge",
      "Womens XSmall",
      "Womens Small",
      "Womens Medium",
      "Womens Large",
      "Womens XLarge",
      "Womens XXLarge"
    ]
  end

  def is_super_admin?
    admin == "super"
  end

  def is_real_admin?
    admin == "super" || admin == "standard"
  end

  def is_captain?
    Team.where("captain_id = :id OR cocaptain_id = :id", id: id).exists?
  end

  def valid_shirt_size?
    User.shirt_sizes.include? shirt_size
  end

  def account_registered?
    phone_number && shirt_size && experience && name? &&
    phone_number.match(/\A\(\d{3}\)\s\d{3}\-\d{4}\z/)
  end

  def drafted?(draft_id)
    !DraftedPlayer.where(player_id: id, draft_id: draft_id).empty?
  end

  def team(league_id = League.current.id)
    teams.find_by(league_id: league_id)
  end

  def on_a_team?(league_id = League.current.id)
    teams.exists?(league_id: league_id)
  end

  def captains_team(league_id = League.current.id)
    Team.where(league_id: league_id).where("captain_id = :id OR cocaptain_id = :id", id: id).first
  end

  def captains_teams
    Team.where("captain_id = :id OR cocaptain_id = :id", id: id)
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
