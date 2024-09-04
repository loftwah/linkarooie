# app/models/waiting_list.rb
class WaitingList < ApplicationRecord
  validates :email, presence: true, 
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
end