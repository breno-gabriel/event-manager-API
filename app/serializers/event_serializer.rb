class EventSerializer < ActiveModel::Serializer
  attributes :id, :name, :description, :date, :location, :status

  has_many :checkin_rules
end