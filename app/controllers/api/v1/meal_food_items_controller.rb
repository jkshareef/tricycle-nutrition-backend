class Api::V1::MealFoodItemsController < ApplicationController
    def create
        @meal_food_item = MealFoodItem.create(meal_food_item_params)
        if @meal_food_item.valid?
            render json: {meal_food_item: MealFoodItemSerializer.new(@meal_food_item)}, status: :accepted
        else
            render json: {error: 'failed to create meal_food_item'}, status: :not_acceptable
        end
    end

    def update
        @meal_food_item = MealFoodItem.find_by(id: params[:id])
        @meal_food_item.update(meal_food_item_params)
        if @meal_food_item.valid?
            render json: {meal_food_item: MealFoodItemSerializer.new(@meal_food_item)}, status: :accepted
        else
            render json: {error: 'failed to update meal_food_item'}, status: :not_acceptable

    end

    def delete
    end




    private

    def meal_food_item_params
        params.require(:meal_food_item).permit(:meal_id, :food_item_id)
    end
end
