class CartCleanupJob < ApplicationJob
  queue_as :default

  def perform
    # Marca como abandonados os carrinhos sem interação há mais de 3 horas
    Cart.where("updated_at < ? AND status != ?", 3.hours.ago, Cart.statuses[:abandoned]).find_each do |cart|
      cart.update(status: :abandoned)
      Rails.logger.info "Carrinho ##{cart.id} marcado como abandonado."
    end

    # Remove carrinhos abandonados há mais de 7 dias
    Cart.where("status = ? AND updated_at < ?", Cart.statuses[:abandoned], 7.days.ago).find_each do |cart|
      cart.destroy
      Rails.logger.info "Carrinho ##{cart.id} removido por abandono prolongado."
    end
  end
end
