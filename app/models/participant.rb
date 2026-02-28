class Participant < ApplicationRecord

  belongs_to :event

  validates :name, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }
  
  validates :check_in_status, inclusion: { in: [true, false] }
end