require 'rails_helper'

RSpec.describe UrlClick, type: :model do
  describe 'associations' do
    it do
      aggregate_failures do
        is_expected.to belong_to :user
        is_expected.to belong_to :url
      end
    end
  end

  describe 'validations' do
    subject { create :url_click }
    it do
      aggregate_failures do
        is_expected.to validate_presence_of :url
        is_expected.to validate_uniqueness_of(:url).scoped_to(:user_id)
      end
    end
  end
end
