class FoodItemCompoundSerializer < ActiveModel::Serializer
  attributes :id, :compound_name, :amount_mg


  def compound_name
    object.compound.name
  end
end
