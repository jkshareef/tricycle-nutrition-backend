class Api::V1::FoodItemCompoundsController < ApplicationController
    
    
    def create
        @food_item_compound = FoodItemCompound.create(food_item_compoound_params)
        if @food_item_compound.valid?
            render json: {food_item_compound: FoodItemSerializer.new(@food_item_compound)}, status: :accepted
        else
            render json: {error: 'failed to create food_item_compound'}, status: :not_acceptable
        end
    end


    



    private

    def food_item_compoound_params
        params.require(:food_item_compound).permit(:food_item_id, :compound_id)
    end
end
