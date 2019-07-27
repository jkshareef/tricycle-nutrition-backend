class CompoundSerializer < ActiveModel::Serializer
  attributes :id, :name, :food_data_id, :description, :unit
end
