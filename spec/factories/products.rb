# spec/factories/products.rb
FactoryBot.define do
  factory :product do
    name { "Produto Exemplo" }
    price { 10.0 }
  end
end
