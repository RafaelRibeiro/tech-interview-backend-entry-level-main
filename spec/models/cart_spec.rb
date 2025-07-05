require 'rails_helper'

RSpec.describe Cart, type: :model do
  context 'when validating' do
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)
      expect(cart.valid?).to be_falsey
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0")
    end
  end

  describe '#mark_abandoned' do
    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      cart = create(:cart, status: :active)
      cart.update_column(:updated_at, 4.hours.ago) # força updated_at no passado sem tocar em callbacks

      expect {
        cart.mark_abandoned
      }.to change { cart.reload.status }.from('active').to('abandoned')
    end
  end

  describe 'remove_if_old' do
    let(:cart) { create(:cart, status: :abandoned, updated_at: 7.days.ago) }

    it 'removes the shopping cart if abandoned for a certain time' do
      cart.mark_abandoned
      expect { cart.remove_if_old }.to change { Cart.count }.by(-1)
    end
  end
end
