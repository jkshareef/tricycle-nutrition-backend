class FoodItemCompoundSerializer < ActiveModel::Serializer
  attributes :id, :compound_name, :amount, :compound


  def compound_name
    object.compound.name
  end
end
