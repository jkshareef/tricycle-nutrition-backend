require 'rest-client'

class Api::V1::MealsController < ApplicationController
  def create
    @meal = Meal.create(meal_params)
    if @meal.valid?
      render json: { meal: MealSerializer.new(@meal) }, status: :accepted
    else
      render json: { error: 'failed to create meal' }, status: :not_acceptable
    end
  end

  def update
    @meal = Meal.find_by(id: params[:id])
    if @meal.update(meal_params)
      render json: { meal: MealSerializer.new(@meal) }, status: :accepted
    else
      render json: { error: 'failed to update meal' }, status: :not_acceptable
    end
  end

  def get_recent
    hash = { data: [] }
    if current_user.meals.size != 0
      all_meals = Meal.where(user_id: current_user.id)
      meals = all_meals.group_by { |meal| Time.now - meal.date }.min.last

      meals.map do |meal|
        counter = 1
        meal.meal_food_items.map do |meal_food_item|
          food_hash = { counter => [] }
          hash[:data].push(food_hash)
          meal_food_item.food_item.food_item_compounds
            .map do |food_item_compound|
            add_hash = {
              food: food_item_compound.food_item.name,
              name: food_item_compound.compound.name,
              amount: food_item_compound.amount,
              rdv: food_item_compound.compound.rdv,
              description: food_item_compound.compound.description,
              units: food_item_compound.compound.units
            }

            idx = hash[:data].index { |h| h.has_key?(counter) }

            hash[:data][idx][counter].push(add_hash)
          end
          counter += 1
        end
      end
      render json: hash, status: :accepted
    else
      render json: { error: 'User has no meals' }, status: :accepted
    end
  end

  def get_food
    hash = { total: [], data: [] }
    if current_user.meals.size != 0
      all_meals = Meal.where(user_id: current_user.id)
      # if params[:time] == "recent"
      #     meals = all_meals.group_by{|meal| Time.now - meal.date}.min.last
      if params[:time] == 'week'
        meals = all_meals.select { |meal| Time.now - meal.date <= 604_800 }
      elsif params[:time] == 'day'
        recent_day_meal =
          all_meals.group_by { |meal| Time.now - meal.date }.min.last
        recent_date = recent_day_meal[0].date.to_s.split(' ')[0]
        meals =
          all_meals.select do |meal|
            meal.date.to_s.split(' ')[0] == recent_date
          end
      elsif params[:time] != nil
        meals =
          all_meals.select do |meal|
            meal.date.to_s.split(' ')[0] == params[:time]
          end
      else
        meals = all_meals.group_by { |meal| Time.now - meal.date }
      end

      meals.map do |meal|
        counter = 1
        meal.meal_food_items.map do |meal_food_item|
          food_hash = { counter => [] }
          hash[:data].push(food_hash)
          meal_food_item.food_item.food_item_compounds
            .map do |food_item_compound|
            total_hash = {
              name: food_item_compound.compound.name,
              amount: food_item_compound.amount,
              rdv: food_item_compound.compound.rdv,
              description: food_item_compound.compound.description,
              units: food_item_compound.compound.units
            }
            add_hash = {
              food: food_item_compound.food_item.name,
              name: food_item_compound.compound.name,
              amount: food_item_compound.amount,
              rdv: food_item_compound.compound.rdv,
              description: food_item_compound.compound.description,
              units: food_item_compound.compound.units
            }
            if hash[:total].size > 0 &&
               hash[:total].index do |h|
                 h[:name] == food_item_compound.compound.name
               end !=
                 nil
              idx =
                hash[:total].index do |h|
                  h[:name] == food_item_compound.compound.name
                end
              if hash[:total][idx][:amount] != nil
                hash[:total][idx][:amount] += food_item_compound.amount

                idx = hash[:data].index { |h| h.has_key?(counter) }
                hash[:data][idx][counter].push(add_hash)
              end
            else
              hash[:total].push(total_hash)
              idx = hash[:data].index { |h| h.has_key?(counter) }
              hash[:data][idx][counter].push(add_hash)
            end
          end
          counter += 1
        end
      end

      render json: hash, status: :accepted
    else
      render json: { error: 'User has no meals' }, status: :accepted
    end
  end

  def add_food
    # response = HTTP.headers('Content-Type' => 'application/json').post('https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/search', :json => {'generalSearchInput' => params[:query]})
    array = params[:query].split(',')
    food_item_ids = []
    array.each do |food|
      if food != ''
        response =
          RestClient.post 'https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/search',
                          { 'generalSearchInput' => food }.to_json,
                          { content_type: :json, accept: :json }

        data = JSON.parse(response.body)

        if data['totalHits'] == 0
          render json: { message: 'No Meals Found' }, status: :accepted
        else
          if food_id_index =
             data['foods'].find_index do |food|
               food['dataType'] == 'Survey (FNDDS)'
             end
            food_id = data['foods'][food_id_index]['fdcId']
          elsif food_id_index =
                data['foods'].find_index do |food|
                  food['dataType'] == 'SR Legacy'
                end
            food_id = data['foods'][food_id_index]['fdcId']
          elsif food_id_index =
                data['foods'].find_index do |food|
                  food['dataType'] == 'Foundation'
                end
            food_id = data['foods'][food_id_index]['fdcId']
          elsif food_id_index =
                data['foods'].find_index do |food|
                  food['dataType'] == 'Branded'
                end
            food_id = data['foods'][food_id_index]['fdcId']
          else
            food_id = data['foods'][0]['fdcID']
          end

          food_name = data['foods'][food_id_index]['description']

          # nutrient_response = HTTP.headers('Content-Type' => 'application/json').get("https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/#{food_id}")
          nutrient_response =
            RestClient.get "https://s79QvmRfTlZsfJLRNGFXVpxRTuozyCnoFrmqMtSJ@api.nal.usda.gov/fdc/v1/#{
                             food_id
                           }",
                           { content_type: :json, accept: :json }
          @food_item = food_item_find_or_create(food_name, food_id)
          food_item_ids.push(@food_item.id)
          nutrient_data = JSON.parse(nutrient_response.body)
          # result_array = []
          nutrient_data['foodNutrients'].map do |food_nutrient|
            name = food_nutrient['nutrient']['name'].downcase
            id = food_nutrient['nutrient']['id']
            unit = food_nutrient['nutrient']['unitName']
            amount = food_nutrient['amount']
            # result_array.push({food_nutrient.nutrient.name.downcase => food_nutrient.nutrient.amount})
            @compound = compound_find_or_create(name, id, unit)
            FoodItemCompound.create(
              food_item_id: @food_item.id,
              compound_id: @compound.id,
              amount: amount
            )
          end
        end
      end
    end

    @meal = current_user.meals.create(date: Time.now)

    food_item_ids.each do |id|
      MealFoodItem.create(meal_id: @meal.id, food_item_id: id)
    end

    render json: { message: 'Success' }, status: :accepted
  end

  private

  def meal_params
    params.require(:meal).permit(:user_id, :date)
  end

  def compound_find_or_create(name, id, unit)
    if Compound.find_by(name: name)
      @compound = Compound.find_by(name: name)
      @compound.update(units: unit)
      @compound
    else
      @compound = Compound.create(name: name, nutrient_id: id, units: unit)
    end
  end

  def food_item_find_or_create(name, id)
    if @food_item = FoodItem.find_by(food_data_id: id)
      @food_item
    else
      @food_item = FoodItem.create(name: name, food_data_id: id)
    end
  end
end
