class UrlClick < ApplicationRecord
  # associations
  belongs_to :url
  belongs_to :user, optional: true
end
