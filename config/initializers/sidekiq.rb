require 'sidekiq'           # Sidekiq
require 'sidekiq-scheduler' # Agendar jobs com base em cron

# Executa quando o Sidekiq estiver rodando como servidor
Sidekiq.configure_server do |config|
  Sidekiq::Scheduler.enabled = true

  schedule_file = Rails.root.join('config/schedule.yml')

  if File.exist?(schedule_file)
    schedule_data = YAML.load_file(schedule_file)  # Carrega o schedule_file correto e atribui a schedule_data

    if schedule_data.is_a?(Hash) && !schedule_data.empty?
      Sidekiq.schedule = schedule_data
      Sidekiq::Scheduler.reload_schedule!
    else
      Rails.logger.warn "[Sidekiq Scheduler] Arquivo schedule.yml carregado, mas o conteúdo não é um Hash válido."
    end
  else
    Rails.logger.warn "[Sidekiq Scheduler] Arquivo schedule.yml não encontrado."
  end
end
