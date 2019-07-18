class Api::V1::FoodItemsController < ApplicationController
    def create
        @food_item = FoodItem.create(food_item_params)
        if @food_item.valid?
            render json: {food_item: FoodItemSerializer.new(@food_item)}, status: :acceptable
        else
            render json: {error: 'failed to create food item'}, status: :not_acceptable
    end

    private

    def food_item_params
        params.require(:food_item).permit(food_data_id, name, compounds)
    end
end
