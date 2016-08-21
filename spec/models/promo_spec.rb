require 'rails_helper'

RSpec.describe Promo, type: :model do
  it 'has a valid factory' do
    expect(build(:promo)).to be_valid
  end

  context 'when it has a nil name' do
    it 'is invalid' do
      expect(build(:promo, name: nil)).not_to be_valid
    end
  end

  context 'when it has an empty name' do
    it 'is invalid' do
      expect(build(:promo, name: '')).not_to be_valid
    end
  end

  context 'when it has a name' do
    it 'is valid' do
      expect(build(:promo, name: 'Sample promo name')).to be_valid
    end
  end
end
