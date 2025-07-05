class CartCleanupJob < ApplicationJob
  queue_as :default

  def perform
    # Marca como abandonados os carrinhos sem interação há mais de 3 horas
    Cart.where("updated_at < ? AND status != ?", 3.hours.ago, Cart.statuses[:abandoned]).find_each do |cart|
      cart.update(status: :abandoned) # Atualiza o status para abandonado
      Rails.logger.info "Carrinho ##{cart.id} marcado como abandonado." # Log
    end

    # Remove carrinhos abandonados há mais de 7 dias
    Cart.where("status = ? AND updated_at < ?", Cart.statuses[:abandoned], 7.days.ago).find_each do |cart|
      cart.destroy # Exclui carrinho
      Rails.logger.info "Carrinho ##{cart.id} removido por abandono prolongado."  # Log
    end
  end
end
