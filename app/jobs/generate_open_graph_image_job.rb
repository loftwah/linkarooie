class GenerateOpenGraphImageJob < ApplicationJob
  queue_as :default

  def perform(user_id)
    user = User.find_by(id: user_id)
    return unless user

    OpenGraphImageGenerator.new(user).generate
  rescue StandardError => e
    Rails.logger.error("Failed to generate OG image for user #{user_id}: #{e.message}")
  end
end