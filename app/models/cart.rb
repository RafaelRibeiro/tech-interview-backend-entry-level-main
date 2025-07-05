class Cart < ApplicationRecord
  has_many :cart_items, dependent: :destroy # Associação de um carrinho para varios itens
  has_many :products, through: :cart_items  # Associação indireta: Um carrinho possui muitos produtos através dos itens no carrinho

  validates_numericality_of :total_price, greater_than_or_equal_to: 0  # Validação e garante que o preço total do carrinho seja um número >= 0

  enum status: { active: 0, abandoned: 1, empty: 2 } # Status do carrinho

  # TODO: lógica para marcar o carrinho como abandonado e remover se abandonado

  # Adiciona ou atualizar um produto no carrinho 
  def add_product(product_id, quantity)
    item = cart_items.find_by(product_id: product_id) # Busca um item existente no carrinho com o mesmo produto

    # Se o item existe
    if item
      item.quantity += quantity  # Soma a quantidade enviada à quantidade atual
      item.save                  # Salva no BD
    # Senão
    else
      item = cart_items.create(product_id: product_id, quantity: quantity) # cria um novo item no carrinho com a quantidade informada
    end

    update_total_price # Chama metodo para calcular e atualizar o preço total do carrinho
    item # Retorna o item
  end

  # Calcula e atualiza o preco total do carrinho
  def update_total_price
    new_total = cart_items.includes(:product).reduce(0) do |sum, item| # Cria um novo total, pegando todos os itens do produto, acumula a partir do 0
      sum + (item.quantity * item.product.price) # Acumulador dos valores + (Qtd de itens * preco do item)
    end

    update_column(:total_price, new_total) # Atualiza a coluna do preco total no BD
  end

  # Verificação se Carrinho está abandonado
  def abandoned?
    updated_at < 3.hours.ago && status != 'abandoned' # Se não houver atualização há mais de 3 horas e não está marcado como abandonado
  end

  # Atualização de Status para Abandonado
  def mark_abandoned

    # Se a ultima atualização for menor ou igual a 3 horas e esteja Ativo
    if updated_at <= 3.hours.ago && active?
      update(status: :abandoned) # Atualiza status abandonar 
    end
  end

  # Verificação se Carrinho deve ser deletado
  def should_be_deleted?
    status == 'abandoned' && updated_at < 7.days.ago # Verifica se o carrinho está abandonado e se a ultima atualização está a mais de 7 dias
  end

  # Remove o carrinho do banco
  def remove_if_old
    destroy if should_be_deleted? # Destroi o carrinho se a verificação do should_be_deleted? retornar true
  end
end
