class Event < ApplicationRecord

  has_many :participants, dependent: :destroy
  has_many :checkin_rules, dependent: :destroy
  
  accepts_nested_attributes_for :checkin_rules, allow_destroy: true

  validates :name, :date, :location, :status, presence: true
  validate :at_least_one_active_rule
  validate :no_mandatory_window_conflicts

  private

  def at_least_one_active_rule
    active_rules = checkin_rules.reject(&:marked_for_destruction?).select(&:is_active)
    if active_rules.empty?
      errors.add(:base, "Deve existir ao menos 1 regra de check-in ativa")
    end
  end

  def no_mandatory_window_conflicts
    relevant_rules = checkin_rules.reject(&:marked_for_destruction?)
                                  .select { |r| r.is_active && r.is_mandatory }

    return if relevant_rules.size <= 1

    max_start = relevant_rules.map(&:start_minutes).max
    min_end = relevant_rules.map(&:end_minutes).min

    if max_start > min_end
      errors.add(:base, "Conflito de janela: as regras obrigatórias não possuem um período de tempo comum para check-in")
    end
  end
end