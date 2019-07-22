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

    # def get_food
    #     hash = {}
    #    if current_user.meals
    #         meals = current_user.meals
    #         meals.map do |meal|
            
    #          meal.meal_food_items.map do |meal_food_item|
    #             meal_food_item.food_item.food_item_compounds.map do |food_item_compound|
    #                     if hash.has_key?(food_item_compound.compound.name)
    #                         byebug
    #                         hash[food_item_compound.compound.name] += food_item_compound.amount_mg
    #                     else
    #                         hash[food_item_compound.compound.name] = food_item_compound.amount_mg
    #                     end
    #                 end
    #             end
    #         end
    #     render json: hash, status: :accepted      
    #    else
    #     render json: {error: 'failed to fetch food items'}, status: :not_acceptable
    #    end
    # end

    def get_food
        hash = {}
       if current_user.meals
            if meals = Meal.where(user_id: current_user.id, date: params[:date])
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
        
        else
            render json: {error: 'User has no meals'}, status: :not_acceptable
        end
    end

    def add_food
        
        response = HTTP.headers({'Content-Type': 'application/json'}).post('https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ
            @api.nal.usda.gov/fdc/v1/search', :body => params[:query])
        
        byebug
        food_id = response.body.foods[0].fdcId
        food_name = response.body.foods[0].description

        nutrient_response = HTTP.headers(:accept => 'application/json')
        .get("https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/#{food_id}")

        @meal = current_user.meals.create(date: Time.now.to_s.split(' ')[0])
        @food_item = FoodItem.create(name: food_name, food_data_id: food_id)
        @meal_food_item = MealFoodItem.create(meal_id: @meal.id, food_item_id: @food_item.id)

        result_array = []
        nutrient_response.body.food_nutrients.map do |food_nutrient|
            if compounds.include?(food_nutrient.nutrient.name.downcase)
                name = food_nutrient.nutrient.name.downcase
                id = food_nutrient.nutrient.id
                amount = food_nutrient.nutrient.amount
                result_array.push({food_nutrient.nutrient.name.downcase => food_nutrient.nutrient.amount})
                @compound = compound_find_or_create(name, id)
                FoodItemCompound.create(food_item_id: @food_item.id, compound_id: @compound.id, amount_mg: amount)
            end
        end

        render json: {message: 'Success'}, status: :accepted

    end

    compounds = [
        "protein", "fiber", "calcium","iron", "iron", "manganese" ,
        "phosphorus", "potassium", "sodium", "zinc", "copper", 
        "selenium", "vitamin_a", "vitamin_e", "vitamin_d", "vitamin_c", 
        "thiamin", "riboflavin", "niacin", "vitamin_b5", "vitamin_b6",
        "vitamin_b12", "choline", "vitamin_k", "folate"]

    def destroy
    end

    

    private

    def meal_params
        params.require(:meal).permit(user_id, date)
    end

    def compound_find_or_create(name, id)
        if !Compound.find_by(name: name)
            Compound.create(name: name, nutrient_id: id)
        end
    end

end
