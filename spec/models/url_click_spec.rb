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
end
