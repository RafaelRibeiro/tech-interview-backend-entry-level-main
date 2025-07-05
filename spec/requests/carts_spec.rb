require 'rails_helper' # Carrega o ambiente de teste do Rails

# Teste para as requisições que vão para o controller do carrinho
RSpec.describe "/cart", type: :request do
  # pending "TODO: Escreva os testes de comportamento do controller de carrinho necessários para cobrir a sua implmentação #{__FILE__}"

  let!(:product) { Product.create!(name: "Notebook", price: 2500.0) } # Cria um produto chamado Notebook com preço de R$2500

  # Teste de Criação de um carrinho
  describe 'POST /cart' do 

    # Testa se o carrinho é criado com um item
    it 'cria um carrinho com item' do 
      post '/cart', params: { product_id: product.id, quantity: 2 }            # Envia uma requisição POST para o caminho /cart com produto e quantidade 2
      expect(response).to have_http_status(:ok)                                # Espera que a resposta http seja 200 OK
      expect(JSON.parse(response.body)["products"].first["quantity"]).to eq(2) # Verifica se a resposta mostra a quantidade correta (2 unidades)
    end

    # Testa se retorna erro quando o produto não existe
    it 'retorna erro se produto não for encontrado' do 
      post '/cart', params: { product_id: 999, quantity: 1 }                     # Tenta adicionar um produto com ID inválido (999)
      expect(response).to have_http_status(:not_found)                           # Espera resposta 404 Not Found
      expect(JSON.parse(response.body)["error"]).to eq("Produto não encontrado") # Verifica se a mensagem de erro está correta
    end
  end

  # Testes para adicionar mais itens ao carrinho
  describe 'POST /cart/add_item' do 

    # Testa se a quantidade do item é atualizada
    it 'altera a quantidade de um item existente' do                
      post '/cart', params: { product_id: product.id, quantity: 1 }          # Cria o carrinho com 1 unidade
      post '/cart/add_item', params: { product_id: product.id, quantity: 3 } # Envia uma nova requisição para mudar para 3 unidades
      expect(response).to have_http_status(:ok)                              # Espera que a resposta seja 200 OK
      body = JSON.parse(response.body)                                       # Converte o JSON da resposta para um hash Ruby
      expect(body["products"].first["quantity"]).to eq(3)                    # Verifica se a quantidade foi atualizada para 3
    end

    # Testa erro se tentar atualizar um item que não está no carrinho
    it 'retorna erro se produto não estiver no carrinho' do 
      post '/cart/add_item', params: { product_id: 999, quantity: 2 }                  # Envia um produto com ID inválido
      expect(response).to have_http_status(:not_found)                                 # Espera resposta 404
      expect(JSON.parse(response.body)["error"]).to eq("Produto não está no carrinho") # Verifica se a mensagem de erro está correta
    end
  end

  # Testes para remover um item do carrinho
  describe 'DELETE /cart/remove_item' do 

    # Testa se o item é removido corretamente
    it 'remove um item do carrinho' do 
      post '/cart', params: { product_id: product.id, quantity: 1 }  # Cria o carrinho com o item
      delete "/cart/#{product.id}", params: { product_id: product.id } # Envia uma requisição DELETE para remover o item
      expect(response).to have_http_status(:ok)                      # Espera resposta 200 OK
      expect(JSON.parse(response.body)["products"]).to be_empty      # Verifica se a lista de produtos ficou vazia
    end
  end
end
