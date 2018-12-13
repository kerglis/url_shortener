class UrlClick < ApplicationRecord
  belongs_to :url
  belongs_to :user, optional: true

  scope :for_url, ->(url) { where(url: url) }
  scope :summary, ->(url) {
    for_url(url).select('url_id, sum(clicks) AS summary').group(:url_id)
  }
end
