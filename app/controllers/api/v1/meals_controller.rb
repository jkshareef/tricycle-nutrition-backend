class Api::V1::MealsController < ApplicationController
    def create
        @meal = Meal.create(meal_params)
        if @meal.valid
            render json: {meal: MealSerializer.new(@meal)}, status: :accepted
        else
            render json: {error: 'failed to create meal'}, status: :not_acceptable
    end

    def edit
        @meal = Meal.find_by(id: params[:id])
        @meal.update(meal_params)

    end

    

    private

    def meal_params
        params.require(:meal).permit(user_id, date, food_items)
    end

    def food_items
        object.food_items
    end
end
