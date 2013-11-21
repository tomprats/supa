class User < ActiveRecord::Base
  has_many :authentications, :dependent => :destroy
  has_and_belongs_to_many :teams

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
  scope :active,   -> { where(active: true) }
  scope :inactive, -> { where(active: false) }

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

  def registered?
    phone_number &&
    experience &&
    shirt_size &&
    name?
  end

  def team
    teams.last
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

  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
end
