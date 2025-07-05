require 'rails_helper' # Carrega o ambiente de teste do Rails

# Teste para o job CartCleanupJob
RSpec.describe CartCleanupJob, type: :job do

  # Grupo de teste para o método perform do job
  describe '#perform' do
    let!(:active_cart) { Cart.create!(status: :active, updated_at: 4.hours.ago) }             # Cria um carrinho ativo, atualizado há 4 horas
    let!(:recent_cart) { Cart.create!(status: :active, updated_at: 1.hour.ago) }              # Cria um carrinho ativo, atualizado há 1 hora
    let!(:old_abandoned_cart) { Cart.create!(status: :abandoned, updated_at: 8.days.ago) }    # Cria um carrinho abandonado, atualizado há 8 dias
    let!(:recent_abandoned_cart) { Cart.create!(status: :abandoned, updated_at: 2.days.ago) } # Cria um carrinho abandonado, atualizado há 2 dias

    # Teste verifica carrinhos inativos como abandonados e remove abandonados antigos
    it 'marca carrinhos inativos como abandonados e remove abandonados antigos' do
      expect {
        described_class.perform_now                                             # Executa o job na imediatamente
      }.to change { active_cart.reload.status }.from("active").to("abandoned")  # Carrinho ativo mude para abandonado
       .and change { Cart.exists?(old_abandoned_cart.id) }.from(true).to(false) # Carrinho abandonado antigo seja apagado
       .and not_change { recent_cart.reload.status }                            # Carrinho recente continue ativo
       .and not_change { Cart.exists?(recent_abandoned_cart.id) }               # Carrinho abandonado recente continue no banco
    end
  end
end
