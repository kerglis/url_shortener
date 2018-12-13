class Url < ApplicationRecord
  belongs_to :user

  validates :user, :url_long, :url_short, presence: true
  validates :url_long, url: true
  validates_uniqueness_of :url_short, case_sensitive: false
  validates :url_short,
            format: {
              with: /\A[a-zA-Z0-9_]+\z/,
              message: 'only allows alpha-numeric and _'
            }

  strip_attributes only: %i[url_long url_short]

  before_validation :generate_url_short

  CHARS = (('a'..'z').to_a + ('A'..'Z').to_a + (0..9).to_a).freeze
  URL_SHORT_LENGTH = 8

  def self.url_short_candidate
    (0...URL_SHORT_LENGTH).map { CHARS[rand(CHARS.size)] }.join
  end

  private

  def generate_url_short
    return if url_short.present?

    # generate `url_short` in loop until it is unique
    loop do
      self.url_short = self.class.url_short_candidate
      break if self.class.where('url_short ilike ?', url_short).empty?
    end
  end
end
