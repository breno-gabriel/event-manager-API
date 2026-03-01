class CheckinRuleSerializer < ActiveModel::Serializer
  attributes :id, :name, :is_mandatory, :is_active, :start_minutes, :end_minutes
end