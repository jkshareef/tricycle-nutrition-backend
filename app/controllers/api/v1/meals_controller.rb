class Api::V1::MealsController < ApplicationController
    def create
        @meal = Meal.create(meal_params)
        if @meal.valid?
            render json: {meal: MealSerializer.new(@meal)}, status: :accepted
        else
            render json: {error: 'failed to create meal'}, status: :not_acceptable
    end

    def update
        @meal = Meal.find_by(id: params[:id])
        if @meal.update(meal_params) 
            render json: {meal: MealSerializer.new(@meal)}, status: :accepted
        else
            render json: {error: 'failed to update meal'}, status: :not_acceptable
    end

    def destroy
    end

    

    private

    def meal_params
        params.require(:meal).permit(user_id, date, food_items)
    end

end
