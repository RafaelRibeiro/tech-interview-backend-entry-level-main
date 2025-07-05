require 'rails_helper'  # Carrega as configurações do ambiente de teste do Rails.

# Testes para o model Product.
RSpec.describe Product, type: :model do

  # Define um contexto para os testes de validação.
  context 'when validating' do 

    # validação de presença do nome está funcionando.
    it 'validates presence of name' do  
      product = described_class.new(price: 100)                   # Cria um produto apenas com o preço.
      expect(product.valid?).to be_falsey                         # Espera que o produto seja inválido.
      expect(product.errors[:name]).to include("can't be blank")  # Espera que o erro seja de nome em branco.
    end

    # Validação de presença do preço está funcionando.
    it 'validates presence of price' do 
      product = described_class.new(name: 'name')                  # Cria um produto apenas com o nome, sem preço.
      expect(product.valid?).to be_falsey                          # Espera que o produto seja inválido.
      expect(product.errors[:price]).to include("can't be blank")  # Espera que o erro seja de preço em branco.
    end

    # Validação de preço precisa ser um número positivo ou zero.
    it 'validates numericality of price' do
      product = described_class.new(price: -1)                                         # Cria um produto com preço negativo.
      expect(product.valid?).to be_falsey                                              # Espera que o produto seja inválido.
      expect(product.errors[:price]).to include("must be greater than or equal to 0")  # Espera erro de valor menor que zero.
    end
  end
end
