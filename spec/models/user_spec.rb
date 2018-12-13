require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'associations' do
    it { is_expected.to have_many :urls }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of :email }

    describe 'email uniqueness' do
      let!(:user) { create :user, email: 'john@doe.com' }
      let(:user2) do
        # all CAPS and whitespace
        build :user, email: ' JOHN@DOE.COM '
      end

      it do
        aggregate_failures do
          expect(user2).to_not be_valid
          expect(user2.errors[:email]).to eq ['has already been taken']
        end
      end
    end
  end
end
