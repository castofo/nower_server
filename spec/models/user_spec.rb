require 'rails_helper'

RSpec.describe User, type: :model do
  it 'has a valid factory' do
    expect(build(:user)).to be_valid
  end

  describe 'first_name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:user, first_name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:user, first_name: '')).not_to be_valid
      end
    end
  end

  describe 'last_name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:user, last_name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:user, last_name: '')).not_to be_valid
      end
    end
  end

  describe 'email' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:user, email: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:user, email: '')).not_to be_valid
      end
    end

    context 'when not containing @' do
      it 'is invalid' do
        expect(build(:user, email: 'hellomail.com')).not_to be_valid
      end
    end

    context 'when not containing domain' do
      it 'is invalid' do
        expect(build(:user, email: 'hello@mail')).not_to be_valid
      end
    end

    context 'when duplicated' do
      let(:existing_user) { create(:user) }
      it 'raises an ActiveRecord::RecordInvalid exception' do
        expect do
          create(:user, email: existing_user.email)
        end.to raise_error ActiveRecord::RecordInvalid
      end
    end
  end

  describe 'password' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:user, password: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:user, password: '')).not_to be_valid
      end
    end
  end

  describe 'birthday' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:user, birthday: nil)).to be_valid
      end
    end
  end

  describe 'gender' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:user, gender: nil)).to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:user, gender: '')).not_to be_valid
      end
    end

    context 'when has more than 1 char' do
      it 'is invalid' do
        long_gender = Faker::Lorem.characters(Faker::Number.between(2, 10))
        expect(build(:user, gender: long_gender)).not_to be_valid
      end
    end

    context 'when F' do
      it 'is valid' do
        expect(build(:user, gender: 'F')).to be_valid
      end
    end

    context 'when M' do
      it 'is valid' do
        expect(build(:user, gender: 'M')).to be_valid
      end
    end

    context 'when not F nor M' do
      it 'is invalid' do
        invalid_chars = ('A'..'Z').to_a - ['F', 'M']
        expect(build(:user, gender: invalid_chars.sample)).not_to be_valid
      end
    end
  end
end
