class AddStatusToCarts < ActiveRecord::Migration[7.1]
  def change
    add_column :carts, :status, :integer, default: 0, null: false # Adição de Coluna status na tabela carts com valor inteiro, padrão 0 e não podendo aceita nulo
  end
end
