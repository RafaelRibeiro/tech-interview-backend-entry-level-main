require 'rails_helper' # Carrega o ambiente de teste do Rails

# Testes para o modelo Cart.
RSpec.describe Cart, type: :model do

  # Contexto para testes de validação.
  context 'when validating' do
    
    # Testa se total_price é um número válido.
    it 'validates numericality of total_price' do
      cart = described_class.new(total_price: -1)                                        # Cria um carrinho com total_price negativo.
      expect(cart.valid?).to be_falsey                                                   # Espera que o carrinho seja inválido.
      expect(cart.errors[:total_price]).to include("must be greater than or equal to 0") # Espera erro no total_price.
    end
  end

  # Testa o método mark_abandoned do Cart.
  describe '#mark_abandoned' do

    # Testa se carrinho vira abandonado após inatividade.
    it 'marks the shopping cart as abandoned if inactive for a certain time' do
      cart = create(:cart, status: :active)        # Cria um carrinho com status ativo.
      cart.update_column(:updated_at, 4.hours.ago) # Altera updated_at para 4 horas atrás.

      expect {
        cart.mark_abandoned                                              # Chama o método para marcar como abandonado.
      }.to change { cart.reload.status }.from('active').to('abandoned')  # Espera que o status mude de ativo para abandonado.
    end
  end

  # Testa o método remove_if_old.
  describe 'remove_if_old' do 
    let(:cart) { create(:cart, status: :abandoned, updated_at: 7.days.ago) }  # Cria um carrinho abandonado há 7 dias.

    it 'removes the shopping cart if abandoned for a certain time' do  # Testa se carrinho antigo é removido.
      cart.mark_abandoned                                              # Marca o carrinho como abandonado (redundante aqui, mas ok).
      expect { cart.remove_if_old }.to change { Cart.count }.by(-1)    # Espera que a contagem de carrinhos diminua em 1.
    end
  end
end
