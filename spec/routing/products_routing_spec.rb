require "rails_helper" # Carrega o ambiente de teste do Rails

# Teste para as rotas do controller ProductsController
RSpec.describe ProductsController, type: :routing do
  describe "routing" do

    # Testa que a rota GET /products está configurada para chamar o método index do ProductsController.
    it "routes to #index" do
      expect(get: "/products").to route_to("products#index") # Espera que GET /products chame products#index
    end

    # Testa que a rota GET /products/1 chama o método show com o parâmetro id = "1".
    it "routes to #show" do
      expect(get: "/products/1").to route_to("products#show", id: "1") # Espera GET /products/1 chamar products#show com id=1
    end

    # Testa que a rota POST /products chama o método create do controller.
    it "routes to #create" do
      expect(post: "/products").to route_to("products#create")  # Espera POST /products chamar products#create
    end

    # Testa que a rota PUT /products/1 chama o método update com o parâmetro id = "1".
    it "routes to #update via PUT" do
      expect(put: "/products/1").to route_to("products#update", id: "1")  # Espera PUT /products/1 chamar products#update com id=1
    end

    # Testa que a rota PATCH /products/1 chama o método update com o parâmetro id = "1".
    it "routes to #update via PATCH" do
      expect(patch: "/products/1").to route_to("products#update", id: "1")  # Espera PATCH /products/1 chamar products#update com id=1
    end

    # Testa que a rota DELETE /products/1 chama o método destroy com o parâmetro id = "1".
    it "routes to #destroy" do
      expect(delete: "/products/1").to route_to("products#destroy", id: "1")  # Espera DELETE /products/1 chamar products#destroy com id=1
    end
  end
end
