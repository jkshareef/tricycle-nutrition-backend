class FoodItemSerializer < ActiveModel::Serializer
  attributes :id, :name, :food_data_id, :food_item_compounds

  # def to_serialized_json
  #   options = {
  #     include: {

  #       }
  #   }
  #   @food_item.to_json(options)
  # end


  # options = {
  #   include: {
  #     bird: {
  #       only: [:name, :species]
  #     },
  #     location: {
  #       only: [:latitude, :longitude]
  #     }
  #   },
  #   except: [:updated_at],
  # }
  # @sighting.to_json(options)
  # }


private



end