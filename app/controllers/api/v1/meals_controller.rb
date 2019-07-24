require 'rest-client'


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
        hash = {data: {}, days: []}
       if current_user.meals
        all_meals = Meal.where(user_id: current_user.id)
            if params[:time] == "day"
                hash[:days].push(all_meals.min_by {|meal| Time.now - meal.date}.date.to_s.split(' ')[0])
                meals = all_meals.group_by{|meal| Time.now - meal.date}.min.last
            elsif params[:time] == "week"
                meals = all_meals.select do |meal|
                    Time.now - meal.date <= 604800
                end
                meals.each do |meal|
                    if !hash[:days].include?(meal.date.to_s.split(' ')[0])
                        hash[:days].push(meal.date.to_s.split(' ')[0])
                    end
                end
                # all_meals.group_by{|meal| Time.now.to_i - Time.new(meal.date).to_i}
                # ending = all_meals.group_by{|meal| Time.now.to_i - Time.new(meal.date).to_i}.length
                # beginning = ending - 6
                # meals = all_meals.group_by{|meal| Time.now.to_i - Time.new(meal.date).to_i}.min[beginning..ending]
            else
                meals = all_meals.group_by{|meal| Time.now.to_i - meal.date}
            end



        meals.map do |meal|
        meal.meal_food_items.map do |meal_food_item|
            meal_food_item.food_item.food_item_compounds.map do |food_item_compound|
                    if hash[:data].has_key?(food_item_compound.compound.name)
                        hash[:data][food_item_compound.compound.name][:amount] += food_item_compound.amount_mg
                    else
                        
                        add_hash = {food_item_compound.compound.name => {:name => food_item_compound.compound.name, 
                            :amount => food_item_compound.amount_mg, :rdv =>food_item_compound.compound.rdv_mg, 
                            :description => food_item_compound.compound.description }}
                        hash[:data].merge!(add_hash)
                        
                        # hash[:data][food_item_compound.compound.name][:amount] = food_item_compound.amount_mg
                        # hash[:data][food_item_compound.compound.name][:rdv] = food_item_compound.compound.rdv_mg
                        # hash[:data][food_item_compound.compound.name][:description] = food_item_compound.compound.description
                    end
                end
            end  
        end
        render json: hash, status: :accepted   
        else
            render json: {error: 'User has no meals'}, status: :not_acceptable
        end
    end

    def add_food
        
        # response = HTTP.headers('Content-Type' => 'application/json').post('https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/search', :json => {'generalSearchInput' => params[:query]})
        response = RestClient.post 'https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/search', {'generalSearchInput' => params[:query]}.to_json, {content_type: :json, accept: :json}
        
        render json: {message: 'Success'}, status: :accepted
        data = JSON.parse(response.body)

      
        
        food_id = data["foods"][0]["fdcId"]
        food_name = data["foods"][0]["description"]

        compounds = [
            "protein", "fiber, total dietary", "calcium","iron", "iron", "manganese, mn" ,
            "magnesium, mg", "phosphorus, p", "potassium, k", "sodium, na", "zinc, zn", "copper, cu", 
            "selenium, se", "vitamin a, iu", "vitamin a, rae", "vitamin e (alpha-tocopherol)", "vitamin_d", "vitamin c, total ascorbic acid", 
            "thiamin", "riboflavin", "niacin", "vitamin_b5", "vitamin b-6",
            "vitamin_b12", "choline", "vitamin k (phylloquinone)", "folate, total"]
    

        # nutrient_response = HTTP.headers('Content-Type' => 'application/json').get("https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/#{food_id}")
        nutrient_response = RestClient.get "https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/#{food_id}", {content_type: :json, accept: :json}

        @meal = current_user.meals.create(date: Time.now)
        @food_item = FoodItem.create(name: food_name, food_data_id: food_id)
        @meal_food_item = MealFoodItem.create(meal_id: @meal.id, food_item_id: @food_item.id)

        nutrient_data = JSON.parse(nutrient_response.body)
        # result_array = []
        nutrient_data["foodNutrients"].map do |food_nutrient|
                name = food_nutrient["nutrient"]["name"].downcase
                id = food_nutrient["nutrient"]["id"]
                amount = food_nutrient["amount"]
                # result_array.push({food_nutrient.nutrient.name.downcase => food_nutrient.nutrient.amount})
                @compound = compound_find_or_create(name, id)
                FoodItemCompound.create(food_item_id: @food_item.id, compound_id: @compound.id, amount_mg: amount)
        end

        

    end

  
    def destroy
    end

    

    private

    def meal_params
        params.require(:meal).permit(user_id, date)
    end

    def compound_find_or_create(name, id)
        if Compound.find_by(name: name)
            @compound = Compound.find_by(name: name)
        else
            @compound = Compound.create(name: name, nutrient_id: id)
        end
    end

end
