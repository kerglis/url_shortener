class UrlClick < ApplicationRecord
  belongs_to :url
  belongs_to :user, optional: true
end
