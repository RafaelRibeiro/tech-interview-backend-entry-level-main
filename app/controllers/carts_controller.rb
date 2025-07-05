class CartsController < ApplicationController
  ## TODO Escreva a lógica dos carrinhos aqui
  
  # Executa Metodo load_or_create_cart antes de qualquer ação
  before_action :load_or_create_cart

  # Criação de Carrinho
  def create
    product = Product.find_by(id: params[:product_id]) # Busca o produto pelo ID pelos params
    return render_not_found('Produto não encontrado') unless product # Retorna caso o produto não for encontrado com mensagem customizada

    cart_item = @cart.add_product(product.id, params[:quantity].to_i) # Adiciona ou atualiza o item no carrinho

    # Verifica se o item existe no BD
    if cart_item.persisted?
      @cart.touch(:updated_at) # Atualiza o updated_at para a hora atual.
      @cart.update(status: :active) # Atualiza status do carrinho para ativo
      render_cart # Chama metodo que Renderiza o carrinho.
    # Senão
    else
      render_unprocessable_entity('Erro ao adicionar produto no carrinho') # Chama metodo que retorna um erro 422 com mensagem.
    end
  end

  # Lista os produtos do carrinho
  def show
    render_cart # Chama metodo que renderiza o carrinho
  end

  # Altera a quantidade de um produto existente no carrinho
  def add_item
    product_id = params[:product_id]   # Captura o ID do produto enviado pelos params
    quantity = params[:quantity].to_i  # Captura a qtd do produto enviado pelos params e converte para inteiro

    cart_item = @cart.cart_items.find_by(product_id: product_id)   # Busca o item no carrinho pelo product_id
    return render_not_found('Produto não está no carrinho') unless cart_item   # Se o item não existir no carrinho, retorna erro 404 com mensagem customizada.

    # Se a quantidade for menor ou igual a 0
    if quantity <= 0
      return render_unprocessable_entity('Quantidade deve ser maior que zero') # Chama metodo que retorna um erro 422 com mensagem.
    end

    cart_item.update(quantity: quantity)   # Atualiza a quantidade do item no banco de dados
    @cart.touch(:updated_at)   # Atualiza o updated_at para a hora atual.
    @cart.update_total_price # Atualiza o preço total do carrinho
    render_cart # Chama metodo que renderiza o carrinho
  end

  # Remove um item do carrinho
  def remove_item
    cart_item = @cart.cart_items.find_by(product_id: params[:product_id])   # Busca o item do carrinho pelo product_id enviado nos params
    return render_not_found('Produto não encontrado no carrinho') unless cart_item # Se o item não existir no carrinho, retorna erro 404 com mensagem customizada.

    cart_item.destroy # Destroi item do carrinho
    @cart.touch(:updated_at) # Atualiza o updated_at para a hora atual.

    # Se o carrinho de itens estiver vazio
    if @cart.cart_items.empty?
      @cart.update(status: :empty) # Atualiza status do carrinho para vazio
    end

    @cart.update_total_price # Atualiza o preço total do carrinho
    render_cart # Chama metodo que renderiza o carrinho
  end

  # Metodos privados 
  private

  # Carrega o carrinho da sessão ou cria um novo
  def load_or_create_cart
    @cart = Cart.find_by(id: session[:cart_id]) # Carrega o carrinho usando o ID armazenado na sessão do usuário

    # Se não encontrar o carrinho
    unless @cart
      @cart = Cart.create!  # Cria um novo carrinho 
      session[:cart_id] = @cart.id # Salva o ID do novo carrinho na sessão para identificar o carrinho nas próximas requisições
    end
  end

  # Renderiza o carrinho
  def render_cart

    # Renderiza a resposta JSON com os dados do carrinho e seus produtos
    render json: {
      id: @cart.id,  # ID do carrinho atual

      # Lista de produtos no carrinho
      products: @cart.cart_items.includes(:product).map do |item| 
        {
          id: item.product.id, # Id do produto
          name: item.product.name, # Nome do produto
          quantity: item.quantity, # Quantidade do produto
          unit_price: item.product.price.to_f, # Preço unitário convertido para decimal
          total_price: (item.quantity * item.product.price).to_f # preço total desse produto convertido para decimal
        }
      end,
      total_price: @cart.total_price.to_f # Preço total de todos os produtos no carrinho convertido para decimal
    }
  end

  # Retorna erro 404 com mensagem customizada no formato json
  def render_not_found(message)
    render json: { error: message }, status: :not_found
  end

  # Retorna erro 422 com mensagem customizada no formato json
  def render_unprocessable_entity(message)
    render json: { error: message }, status: :unprocessable_entity
  end
end
