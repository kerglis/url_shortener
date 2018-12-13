class UrlClick < ApplicationRecord
  # associations
  belongs_to :url
  belongs_to :user, optional: true

  # validations
  validates :url,
            presence: true,
            uniqueness: { scope: :user_id }
end
