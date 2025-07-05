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
      # Executa o job
      expect {
        described_class.perform_now # Executa o job imediatamente.
      }.to change { active_cart.reload.status }.from("active").to("abandoned")  # Espera que o status do carrinho ativo mude de "active" para "abandoned".
       .and change { Cart.exists?(old_abandoned_cart.id) }.from(true).to(false) # Espera que o carrinho abandonado antigo seja removido do banco.

      # Verifica que o carrinho recente ainda está ativo
      expect(recent_cart.reload.status).to eq("active")

      # Verifica que o carrinho abandonado recente ainda existe
      expect(Cart.exists?(recent_abandoned_cart.id)).to eq(true)
    end
  end
end
