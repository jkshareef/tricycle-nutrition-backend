class Api::V1::MealsController < ApplicationController
    def create
        @meal = Meal.create(meal_params)
        if @meal.valid?
            render json: {meal: MealSerializer.new(@meal)}, status: :accepted
        else
            render json: {error: 'failed to create meal'}, status: :not_acceptable
        end
    end

    def update
        @meal = Meal.find_by(id: params[:id])
        if @meal.update(meal_params) 
            render json: {meal: MealSerializer.new(@meal)}, status: :accepted
        else
            render json: {error: 'failed to update meal'}, status: :not_acceptable
        end
    end

    def get_food
        hash = {}
       if current_user.meals
            meals = current_user.meals
            meals.map do |meal|
            
             meal.meal_food_items.map do |meal_food_item|
                meal_food_item.food_item.food_item_compounds.map do |food_item_compound|
                        if hash.has_key?(food_item_compound.compound.name)
                            byebug
                            hash[food_item_compound.compound.name] += food_item_compound.amount_mg
                        else
                            hash[food_item_compound.compound.name] = food_item_compound.amount_mg
                        end
                    end
                end
            end
        render json: hash, status: :accepted      
       else
        render json: {error: 'failed to fetch food items'}, status: :not_acceptable
       end
    end

    def destroy
    end

    

    private

    def meal_params
        params.require(:meal).permit(user_id, date)
    end

end
