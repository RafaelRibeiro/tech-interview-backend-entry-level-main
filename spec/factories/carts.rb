# spec/factories/carts.rb
FactoryBot.define do
  factory :cart do
    status { :active }
    total_price { 0 }
  end
end