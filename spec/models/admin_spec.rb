require 'rails_helper'

RSpec.describe Admin, type: :model do
  it 'has a valid factory' do
    expect(build(:admin)).to be_valid
  end

  describe 'first_name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:admin, first_name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:admin, first_name: '')).not_to be_valid
      end
    end
  end

  describe 'last_name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:admin, last_name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:admin, last_name: '')).not_to be_valid
      end
    end
  end

  describe 'email' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:admin, email: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:admin, email: '')).not_to be_valid
      end
    end

    context 'when not containing @' do
      it 'is invalid' do
        expect(build(:admin, email: 'hellomail.com')).not_to be_valid
      end
    end

    context 'when not containing domain' do
      it 'is invalid' do
        expect(build(:admin, email: 'hello@mail')).not_to be_valid
      end
    end

    context 'when duplicated' do
      let(:existing_admin) { create(:admin) }
      it 'raises an ActiveRecord::RecordInvalid exception' do
        expect do
          create(:admin, email: existing_admin.email)
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'password' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:admin, password: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:admin, password: '')).not_to be_valid
      end
    end

    context 'when has less than 8 characters' do
      it 'is invalid' do
        password_length = Faker::Number.between(1, 7)
        expect(build(:admin, password: Faker::Lorem.characters(password_length))).not_to be_valid
      end
    end

    context 'when has exactly 8 characters' do
      it 'is valid' do
        expect(build(:admin, password: Faker::Lorem.characters(8))).to be_valid
      end
    end

    context 'when has more than 8 characters' do
      it 'is valid' do
        password_length = Faker::Number.between(9, 30)
        expect(build(:admin, password: Faker::Lorem.characters(password_length))).to be_valid
      end
    end
  end

  describe 'admin_type' do
    context 'when is nil' do
      it 'is invalid' do
        expect(build(:admin, admin_type: nil)).not_to be_valid
      end
    end
  end

  describe 'privileges' do
    context 'when is an array' do
      it 'is valid' do
        expect(build(:admin, privileges: [])).to be_valid
      end
    end
  end

  describe 'activated_at' do
    context 'when nil' do
      context 'and new record' do
        it 'is valid' do
          expect(build(:admin, activated_at: nil)).to be_valid
        end
      end

      context 'and not new record' do
        context 'and activated_at was nil' do
          let!(:existing_admin) { create(:admin, activated_at: nil) }
          it 'is valid' do
            existing_admin.activated_at = nil
            expect(existing_admin).to be_valid
          end
        end

        context 'and activated_at was not nil' do
          let!(:existing_admin) { create(:admin_activated) }
          it 'is invalid' do
            existing_admin.activated_at = nil
            expect(existing_admin).not_to be_valid
          end
        end
      end
    end

    context 'when was not nil and changed its value' do
      let!(:existing_admin) { create(:admin_activated) }
      it 'is invalid' do
        existing_admin.activated_at = Faker::Date.between(10.hours.ago, 1.hour.ago)
        expect(existing_admin).not_to be_valid
      end
    end

    context 'when is after current date' do
      it 'is invalid' do
        admin = build(:admin, activated_at: Faker::Number.between(1, 3600).hours.from_now)
        expect(admin).not_to be_valid
      end
    end

    context 'when is before or equals current date' do
      it 'is valid' do
        admin = build(:admin, activated_at: Faker::Number.between(0, 3600).hours.ago)
        expect(admin).to be_valid
      end
    end
  end
end
