require 'rails_helper'

RSpec.describe Store, type: :model do
  it 'has a valid factory' do
    expect(build(:store)).to be_valid
  end

  describe 'name' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:store, name: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:store, name: '')).not_to be_valid
      end
    end

    context 'with more than 50 characters' do
      it 'is invalid' do
        expect(build(:store, name: Faker::Lorem.characters(51))).to be_invalid
      end
    end

    context 'with no more than 50 characters' do
      it 'is valid' do
        name = Faker::Lorem.characters(Faker::Number.between(1, 50)) # From 1 to 50 characters
        expect(build(:store, name: name)).to be_valid
      end
    end
  end

  describe 'description' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:store, description: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:store, description: '')).not_to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:store)).to be_valid
      end
    end
  end

  describe 'nit' do
    context 'when nil' do
      it 'is invalid' do
        expect(build(:store, nit: nil)).not_to be_valid
      end
    end

    context 'when empty' do
      it 'is invalid' do
        expect(build(:store, nit: '')).not_to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:store)).to be_valid
      end
    end
  end

  describe 'website' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:store, website: nil)).to be_valid
      end
    end

    context 'when empty' do
      it 'is valid' do
        expect(build(:store, website: '')).to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:store)).to be_valid
      end
    end
  end

  describe 'address' do
    context 'when nil' do
      it 'is valid' do
        expect(build(:store, address: nil)).to be_valid
      end
    end

    context 'when empty' do
      it 'is valid' do
        expect(build(:store, address: '')).to be_valid
      end
    end

    context 'when not empty' do
      it 'is valid' do
        expect(build(:store)).to be_valid
      end
    end
  end

  describe 'status' do
    context 'when is nil' do
      it 'is invalid' do
        expect(build(:store, status: nil)).not_to be_valid
      end
    end

    context 'when is empty' do
      it 'is invalid' do
        expect(build(:store, status: '')).not_to be_valid
      end
    end

    context 'when is pending_documentation' do
      it 'is valid' do
        expect(build(:store, status: :pending_documentation)).to be_valid
      end
    end

    context 'when is active' do
      it 'is valid' do
        expect(build(:store, status: :active)).to be_valid
      end
    end

    context 'when is closed' do
      it 'is valid' do
        expect(build(:store, status: :closed)).to be_valid
      end
    end

    context 'when is denied' do
      it 'is valid' do
        expect(build(:store, status: :denied)).to be_valid
      end
    end

    context 'when is blocked' do
      it 'is valid' do
        expect(build(:store, status: :blocked)).to be_valid
      end
    end

    context 'when is not a proper value' do
      it 'is invalid' do
        expect(build(:store, status: Faker::Lorem.sentence)).not_to be_valid
      end
    end
  end
end
