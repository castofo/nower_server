require 'rails_helper'

RSpec.describe Branch, type: :model do
  it 'has a valid factory' do
    expect(build(:branch)).to be_valid
  end

  describe 'name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:branch, name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:branch, name: '')).not_to be_valid
      end
    end

    context 'with more than 35 characters' do
      it 'is invalid' do
        expect(build(:branch, name: Faker::Lorem.characters(36))).to be_invalid
      end
    end

    context 'with no more than 35 characters' do
      it 'is valid' do
        name = Faker::Lorem.characters(Faker::Number.between(1, 35)) # From 1 to 35 characters
        expect(build(:branch, name: name)).to be_valid
      end
    end
  end

  describe 'latitude' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:branch, latitude: nil)).not_to be_valid
      end
    end

    context 'when float value' do
      it 'is valid' do
        expect(build(:branch)).to be_valid
      end
    end
  end

  describe 'longitude' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:branch, longitude: nil)).not_to be_valid
      end
    end

    context 'when float value' do
      it 'is valid' do
        expect(build(:branch)).to be_valid
      end
    end
  end

  describe 'address' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:branch, address: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:branch, address: '')).not_to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:branch)).to be_valid
      end
    end
  end

  describe 'default_contact_info' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:branch, address: nil)).not_to be_valid
      end
    end

    context 'when boolean value' do
      it 'is valid' do
        expect(build(:branch)).to be_valid
      end
    end
  end
end
