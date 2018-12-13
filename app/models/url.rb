class Url < ApplicationRecord
  attr_writer :manual_url_short

  # constants
  CHARS = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).freeze
  URL_SHORT_LENGTH = 8

  # associations
  belongs_to :user
  has_many :url_clicks, dependent: :destroy

  # validations
  validates :user, :url_long, :url_short,
            presence: true
  validates :url_long, url: true
  validates :url_short,
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: 'only allows alpha-numeric and _'
            },
            uniqueness: {
              case_sensitive: false
            }

  # scopes
  scope :with_click_summary, -> {
    joins('LEFT JOIN url_clicks ON url_clicks.url_id = urls.id')
      .select('urls.*, sum(url_clicks.clicks) AS click_summary')
      .group('urls.id, url_clicks.url_id')
  }

  # callbacks
  strip_attributes only: %i[url_long url_short manual_url_short]
  before_validation :generate_url_short

  def self.url_short_candidate
    # generate string of random chars - URL_SHORT_LENGTH long
    (0...URL_SHORT_LENGTH).map { CHARS[rand(CHARS.size)] }.join
  end

  def manual_url_short
    @manual_url_short ||= url_short
  end

  def register_click!(user = nil)
    Urls::RegisterClick.new(self, user).call
  end

  private

  def generate_url_short
    if manual_url_short.present?
      self.url_short = manual_url_short.strip
      return
    end

    return if url_short.present?

    loop do
      # generate `url_short` in loop until it is unique

      self.url_short = self.class.url_short_candidate
      break if self.class.where('url_short ilike ?', url_short).empty?
    end
  end
end
