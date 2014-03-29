class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_many :announcements
  has_and_belongs_to_many :teams
  has_many :drafted_players, :foreign_key => :player_id, :dependent => :destroy
  has_many :draft_players, :foreign_key => :player_id, :dependent => :destroy
  has_many :draft_groups, :foreign_key => :captain_id, :dependent => :destroy
  has_one :questionnaire, :dependent => :destroy
  has_many :stats, class_name: "PlayerStat", foreign_key: :player_id, dependent: :destroy

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
  scope :registered, -> { where(spring_registered: true) }
  scope :unregistered, -> { where(spring_registered: false) }
  scope :current, -> { includes(:teams).where.not(teams: { id: nil }) }

  def self.default_scope
    order("last_name ASC")
  end

  def apply_omniauth(omni)
    authentications.build(:provider => omni['provider'],
                          :uid => omni['uid'],
                          :token => omni['credentials'].token,
                          :token_secret => omni['credentials'].secret)
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
    Team.where(:captain_id => id).count > 0
  end

  def account_registered?
    phone_number &&
    (phone_number.length == 14) &&
    experience &&
    shirt_size &&
    name?
  end

  def spring_registered?
    spring_registered
  end

  def drafted?(draft_id)
    !DraftedPlayer.where(:player_id => id,
                        :draft_id => draft_id).empty?
  end

  def team
    teams.last
  end

  def captains_team
    captains_teams.last
  end

  def captains_teams
    Team.where(:captain_id => id)
  end

  def drafts
    drafts = []
    captains_teams.each do |dteam|
      drafts += Draft.where("season = ? AND year = ?", dteam.season, dteam.year)
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
    paid
  end

  def games_played
    stats.map(&:team_stats).uniq.count
  end

  def assists
    stats.reduce(0){|sum, s| sum + s.assists.to_i }
  end

  def goals
    stats.reduce(0){|sum, s| sum + s.goals.to_i }
  end

  def points
    assists + goals
  end

  def points_per_game
    if games_played.zero?
      0
    else
      (points/games_played).round(2)
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
