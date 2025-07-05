require 'rails_helper' # Carrega o ambiente de teste do Rails

# Teste para o model CartItem
RSpec.describe CartItem, type: :model do

  # Testes de relacionamento de tabela
  describe 'associações' do
    it { should belong_to(:cart) }    # Verifica se CartItem pertence a um carrinho
    it { should belong_to(:product) } # Verifica se CartItem pertence a um produto
  end

  # Testes para o método que atualiza o preço total do carrinho
  describe '#update_total_price' do
    
    # Recalcula corretamente o total do carrinho
    it 'atualiza o preço total do carrinho corretamente' do
      product = Product.create!(name: "Produto", price: 10.0)            # Cria um produto com preço 10 reais
      cart = Cart.create!(total_price: 0)                                # Cria um carrinho com total inicial zero
      item = CartItem.create!(cart: cart, product: product, quantity: 3) # Cria um item com quantidade 3 e produto vinculado
      item.update_total_price                                            # Chama o método que atualiza o total do carrinho
      expect(cart.reload.total_price).to eq(30.0)                        # Espera que o total do carrinho seja atualizado para 30 reais
    end
  end
end
