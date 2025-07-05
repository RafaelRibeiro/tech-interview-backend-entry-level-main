class CartItem < ApplicationRecord
  belongs_to :cart
  belongs_to :product
  
  def update_total_price
    total = cart.cart_items.sum { |item| item.quantity * item.product.price }
    cart.update(total_price: total)
  end
end
