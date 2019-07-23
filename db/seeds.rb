# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)

Compound.destroy_all
User.destroy_all
FoodItem.destroy_all
Meal.destroy_all
MealFoodItem.destroy_all
FoodItemCompound.destroy_all


def seed_compounds
    Compound.create(name: "protein", nutrient_id:1003, description: "for muscles", rdv_mg: 20000 )
    Compound.create(name: "fiber, total dietary", nutrient_id:1079 , description:"for digestive", rdv_mg: nil)
    Compound.create(name: "calcium, ca", nutrient_id:1087, description:"for bones", rdv_mg: nil)
    Compound.create(name: "iron, fe", nutrient_id:1089, description:"for blood", rdv_mg: 15)
    Compound.create(name: "magnesium, mg", nutrient_id:1090, description: "", rdv_mg:nil)
    Compound.create(name: "manganese, mn", nutrient_id:1101, description: "", rdv_mg:nil)
    Compound.create(name: "phosphorus, p", nutrient_id:1091, description:"", rdv_mg:nil)
    Compound.create(name: "potassium, k", nutrient_id:1092, description:"", rdv_mg:nil)
    Compound.create(name: "sodium, na", nutrient_id:1093, description:"", rdv_mg:nil)
    Compound.create(name: "zinc, sn", nutrient_id:1095, description: "", rdv_mg:nil)
    Compound.create(name: "copper, cu", nutrient_id:1098, description:"", rdv_mg:nil)
    Compound.create(name: "selenium, se", nutrient_id:1103, description:"", rdv_mg:nil)
    Compound.create(name: "vitamin a, iu", nutrient_id:1106, description:"", rdv_mg:nil)
    Compound.create(name: "vitamin a, rae", nutrient_id:1106, description:"", rdv_mg:nil)
    Compound.create(name: "vitamin e (alpha-tocopherol)", nutrient_id:1109, description:"", rdv_mg:nil)
    Compound.create(name: "vitamin d (d2 + d3)", nutrient_id:1114, description:"for bones", rdv_mg: nil)
    Compound.create(name: "vitamin c, ascorbic acid", nutrient_id:1162, description:"for immune", rdv_mg: nil )
    Compound.create(name: "thiamin", nutrient_id:1165, description:"", rdv_mg:nil )
    Compound.create(name: "riboflavin", nutrient_id:1166, description:"", rdv_mg: nil )
    Compound.create(name: "niacin", nutrient_id:1167, description:"", rdv_mg: nil )
    Compound.create(name: "vitamin b-5", nutrient_id:1170, description:"", rdv_mg: nil)
    Compound.create(name: "vitamin b-6", nutrient_id:1175, description:"", rdv_mg: nil)
    Compound.create(name: "vitamin b12", nutrient_id:1178, description:"", rdv_mg: nil)
    Compound.create(name: "choline", nutrient_id:1180, description:"", rdv_mg: nil)
    Compound.create(name: "vitamin k (phylloquinone)", nutrient_id:1185, description:"", rdv_mg: nil )
    Compound.create(name: "folate, total", nutrient_id:1177, description:"", rdv_mg: nil)
end

def seed_food_items
    FoodItem.create(name: "cheddar cheese", food_data_id:336711)
    FoodItem.create(name: "kale" , food_data_id: 511744)
    FoodItem.create(name: "apple" , food_data_id:168204)
    FoodItem.create(name: "cashews" , food_data_id:17062)
    FoodItem.create(name: "avocado", food_data_id:562115)
    FoodItem.create(name: "salmon", food_data_id:462972)
end

def seed_meals
jamal = User.create(name: "Jamal Shareef", username: "Jshareef", password: "1234")
kendall = User.create(name: "Kendall Shareef", username: "Kshareef", password: "1234")
jamal.meals.create([
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
end

def seed_meal_food_items
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

def seed_food_item_compounds
    FoodItemCompound.create(food_item_id: 1, compound_id:3, amount_mg: 200)
    FoodItemCompound.create(food_item_id: 1, compound_id:4, amount_mg: 100)
    FoodItemCompound.create(food_item_id: 1, compound_id: 5, amount_mg:100)
    FoodItemCompound.create(food_item_id: 1, compound_id: 6, amount_mg:500)
    FoodItemCompound.create(food_item_id: 1, compound_id: 7, amount_mg:200)
    FoodItemCompound.create(food_item_id: 3, compound_id:1, amount_mg: 100)
    FoodItemCompound.create(food_item_id: 3, compound_id:2, amount_mg:50)
    FoodItemCompound.create(food_item_id: 4, compound_id:3, amount_mg:75)
    FoodItemCompound.create(food_item_id: 4, compound_id:4, amount_mg:100)
    FoodItemCompound.create(food_item_id: 4, compound_id:5, amount_mg:250)
    FoodItemCompound.create(food_item_id: 4, compound_id:6, amount_mg:300)
    FoodItemCompound.create(food_item_id: 4, compound_id:7, amount_mg: 210)
end

seed_compounds
seed_food_items
seed_meals
seed_meal_food_items
seed_food_item_compounds




