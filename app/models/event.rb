class Event < ApplicationRecord

  has_many :participants, dependent: :destroy

  validates :name, :date, :location, :status, presence: true
  validates :description, length: { maximum: 2000 }, allow_blank: true

  enum :status, { active: 0, closed: 1 }
end