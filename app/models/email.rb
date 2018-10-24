class Email < ApplicationRecord
  belongs_to :owner, class_name: "User"

  validates_presence_of :body, :subject
  validate :verify_unsent

  before_save :verify_integrity
  before_destroy :require_unsent

  def self.default_scope
    order(created_at: :desc)
  end

  def can_preview?
    error = "Already Previewed" if previewed?

    errors.add(:base, error) if error
    errors.blank?
  end

  def can_send?
    error = "Already Sent" if sent?
    error ||= "Unpreviewed Email" unless previewed?
    error ||= "Unpreviewed Email (10 minute delay)" unless 10.minutes.ago > updated_at

    errors.add(:base, error) if error
    errors.blank?
  end

  def body_html
    Rails.cache.fetch(self) do
      markdown = Redcarpet::Markdown.new(Redcarpet::Render::HTML, autolink: true, tables: true)
      markdown.render(body).html_safe
    end
  end

  private
  def already_sent
    errors.add(:base, "Email has already been sent")
  end

  def require_unsent
    verify_unsent

    throw(:abort) if errors.any?
  end

  def verify_integrity
    self.previewed = false if body_changed? || subject_changed?
  end

  def verify_unsent
    already_sent if sent_was
  end
end
