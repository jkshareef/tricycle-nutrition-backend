# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Compound.destroy_all

def compounds
    Compound.create(name: "protein", nutrient_id:1003, description: "for muscles")
    Compound.create(name: "fiber", nutrient_id:1079 , description:"for digestive")
    Compound.create(name: "calcium", nutrient_id:1087, description:"for bones")
    Compound.create(name: "iron", nutrient_id:,1089 description:"for blood")
    Compound.create(name: "magnesium", nutrient_id:1090, description:)
    Compound.create(name: "manganese", nutrient_id:1101, description:)
    Compound.create(name: "phosphorus", nutrient_id:1091, description:)
    Compound.create(name: "potassium", nutrient_id:1092, description:)
    Compound.create(name: "sodium", nutrient_id:1093, description:)
    Compound.create(name: "zinc", nutrient_id:1095, description:)
    Compound.create(name: "copper", nutrient_id:1098, description:)
    Compound.create(name: "manganese", nutrient_id:, description:)
    Compound.create(name: "selenium", nutrient_id:1103, description:)
    Compound.create(name: "vitamin_a", nutrient_id:1106, description:)
    Compound.create(name: "vitamin_e", nutrient_id:1109, description:)
    Compound.create(name: "vitamin_d", nutrient_id:1114, description:"for bones")
    Compound.create(name: "vitamin_c", nutrient_id:1162, description:"for immune")
    Compound.create(name: "thiamin", nutrient_id:1165, description:)
    Compound.create(name: "riboflavin", nutrient_id:1166, description:)
    Compound.create(name: "niacin", nutrient_id:1167, description:)
    Compound.create(name: "vitamin_b5", nutrient_id:1170, description:)
    Compound.create(name: "vitamin_b6", nutrient_id:1175, description:)
    Compound.create(name: "vitamin_b12", nutrient_id:1178, description:)
    Compound.create(name: "choline", nutrient_id:1180, description:)
    Compound.create(name: "vitamin_k", nutrient_id:1185, description:)
    Compound.create(name: "folate", nutrient_id:1177, description:)

    FoodItem.create(name: "cheddar cheese", food_data_id:336711)
    FoodItem.create(name: "kale" , food_data_id: 511744)
    FoodItem.create(name: "apple" , food_data_id:168204)
    FoodItem.create(name: "cashews" , food_data_id:17062)
    FoodItem.create(name: "avocado", food_data_id:562115)
    FoodItem.create(name: "salmon", food_data_id:462972)
end

jamal = User.create(name: "Jamal Shareef" username: "jshareef" password: "winston")
jamal.meals.build([
    {date: Time.now},
    {date: Time.now},
    {date: Time.now},
    {date: Time.now + (60*60*24)},
    {date: Time.now + (60*60*24)},
    {date: Time.now + (60*60*24)},
    {date: Time.now - (60*60*24)},
    {date: Time.now - (60*60*24)},
    {date: Time.now - (60*60*24)}
])

def meal_food_items
    MealFoodItem.create(meal_id:1, food_item_id:1)
    MealFoodItem.create(meal_id:1, food_item_id:2)
    MealFoodItem.create(meal_id:1, food_item_id:3)
    MealFoodItem.create(meal_id:1, food_item_id:4)
    MealFoodItem.create(meal_id:1, food_item_id:3)
    MealFoodItem.create(meal_id:1, food_item_id:6)
    MealFoodItem.create(meal_id:2, food_item_id:5)
    MealFoodItem.create(meal_id:2, food_item_id:2)
    MealFoodItem.create(meal_id:2, food_item_id:3)
    MealFoodItem.create(meal_id:2, food_item_id:1)
    MealFoodItem.create(meal_id:2, food_item_id:2)
    MealFoodItem.create(meal_id:2, food_item_id:4)
    MealFoodItem.create(meal_id:3, food_item_id:4)
    MealFoodItem.create(meal_id:3, food_item_id:5)
    MealFoodItem.create(meal_id:3, food_item_id:3)
    MealFoodItem.create(meal_id:3, food_item_id:2)
    MealFoodItem.create(meal_id:3, food_item_id:1)
    MealFoodItem.create(meal_id:3, food_item_id:1)
end

def food_item_compounds
    FoodItemCompound.create(food_item_id: 1, compound_id:3)
    FoodItemCompound.create(food_item_id: 1, compound_id:4)
    FoodItemCompound.create(food_item_id: 1, compound_id: 5)
    FoodItemCompound.create(food_item_id: 1, compound_id: 6)
    FoodItemCompound.create(food_item_id: 1, compound_id: 7)
    FoodItemCompound.create(food_item_id: 3, compound_id:1)
    FoodItemCompound.create(food_item_id: 3, compound_id:2)
    FoodItemCompound.create(food_item_id: 4, compound_id:3)
    FoodItemCompound.create(food_item_id: 4, compound_id:4)
    FoodItemCompound.create(food_item_id: 4, compound_id:5)
    FoodItemCompound.create(food_item_id: 4, compound_id:6)
    FoodItemCompound.create(food_item_id: 4, compound_id:7)
end




