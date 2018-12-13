class User < ApplicationRecord
  # associations
  has_many :urls, dependent: :destroy
  has_many :url_clicks, dependent: :destroy

  # gem calls
  devise :database_authenticatable, :registerable, :recoverable,
         :rememberable, :validatable
end
