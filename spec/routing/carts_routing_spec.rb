require "rails_helper" # Carrega o ambiente de teste do Rails

# Teste para as rotas do controller CartsController
RSpec.describe CartsController, type: :routing do 

  # Testa se GET /cart vai para o método show
  it 'routes to #show' do 
    expect(get: '/cart').to route_to('carts#show') # Espera que GET /cart direcione para carts#show
  end

  # Testa se POST /cart vai para o método create
  it 'routes to #create' do 
    expect(post: '/cart').to route_to('carts#create') # Espera que POST /cart direcione para carts#create
  end

  # Testa se POST /cart/add_item vai para o método add_item
  it 'routes to #add_item' do 
    expect(post: '/cart/add_item').to route_to('carts#add_item') # Espera que POST /cart/add_item direcione para carts#add_item
  end

  # Testa se DELETE /cart/remove_item vai para o método remove_item
  it 'routes to #remove_item' do 
      expect(delete: '/cart/1').to route_to('carts#remove_item', product_id: '1') # Espera que DELETE /cart/product_id direcione para carts#remove_item
  end
end
