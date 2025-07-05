class MarkCartAsAbandonedJob
  include Sidekiq::Job # Job do Sidekiq
  

  queue_as :default    # Job colocado na fila "default"

  def perform(*args)

    # Marca como abandonado 
    Cart.where("updated_at < ? AND status = ?", 3.hours.ago, Cart.statuses[:active]).find_each do |cart| # Procura carrinhos inativos há mais de 3 horas
      cart.update(status: :abandoned) # Atualiza Status para abandonado
      Rails.logger.info "Carrinho ##{cart.id} marcado como abandonado" # Log para usuario
    end

    # Remove carrinhos abandonados
    Cart.where("updated_at < ? AND status = ?", 7.days.ago, Cart.statuses[:abandoned]).find_each do |cart| # Procura carrinhos abandonados há mais de 7 dias
      cart.destroy # Destroi Carrinho
      Rails.logger.info "Carrinho ##{cart.id} removido por abandono prolongado" # Log para usuario
    end
  end
end
