# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
require 'smarter_csv' 
require 'parallel'





Compound.destroy_all
User.destroy_all
FoodItem.destroy_all
Meal.destroy_all
MealFoodItem.destroy_all
FoodItemCompound.destroy_all



def seed_compounds
    rows = SmarterCSV.process("./csv/FoodData_Central_csv_2019-04-02/nutrient.csv", :key_mapping => {:id => :nutrient_id, :unit_name => :units, :name => :name})

    rows.each do |hash|
        Compound.create(name: hash[:name], nutrient_id: hash[:nutrient_id], units: hash[:units])
    end
end

def seed_food_items
    # arr_of_rows = CSV.read("./csv/FoodData_Central_csv_2019-04-02/food.csv")
    # arr_of_rows.shift

    # arr_of_rows.each do |row|
    #     FoodItem.create(name: row[2], food_data_id: row[0])
    # end

    chunks = SmarterCSV.process("./csv/FoodData_Central_csv_2019-04-02/food.csv", {chunk_size: 1000, :key_mapping => {:description => :name, :fdc_id => :food_data_id}})

    Parallel.map(chunks) do |chunk|
        chunk.each do |hash|
            FoodItem.create(name: hash[:name], food_data_id: hash[:food_data_id])
        end
    end
end

def seed_food_item_compounds
    # arr_of_rows = CSV.read("./csv/FoodData_Central_csv_2019-04-02/food_nutrient.csv")
    # arr_of_rows.shift

    # arr_of_rows.each do |row|
    #     food_item = FoodItem.find_by(food_data_id: row[1])
    #     compound = Compound.find_by(nutrient_id: row[2])
    #     FoodItemCompound.create(food_item_id: food_item.id, compound_id: compound.id, amount: row[3])
    # end


    chunks = SmarterCSV.process("./csv/FoodData_Central_csv_2019-04-02/food_nutrient.csv", {chunk_size: 1000, :key_mapping => {:fdc_id => :food_data_id}})
    Parallel.map(chunks) do |chunk|
        chunk.each do |hash|
            food_item = FoodItem.find_by(food_data_id: hash[:food_data_id]) 
            compound = Compound.find_by(nutrient_id: hash[:nutrient_id])
            FoodItemCompound.create(food_item_id: food_item.id, compound_id: compound.id, amount: hash[:amount])
        end 
    end
end



# def seed_food_items
#     FoodItem.create(name: "cheddar cheese", food_data_id:336711)
#     FoodItem.create(name: "kale" , food_data_id: 511744)
#     FoodItem.create(name: "apple" , food_data_id:168204)
#     FoodItem.create(name: "cashews" , food_data_id:17062)
#     FoodItem.create(name: "avocado", food_data_id:562115)
#     FoodItem.create(name: "salmon", food_data_id:462972)
# end


# def seed_food_item_compounds
#     FoodItemCompound.create(food_item_id: 1, compound_id:3, amount_mg: 200)
#     FoodItemCompound.create(food_item_id: 1, compound_id:4, amount_mg: 100)
#     FoodItemCompound.create(food_item_id: 1, compound_id: 5, amount_mg:100)
#     FoodItemCompound.create(food_item_id: 1, compound_id: 6, amount_mg:500)
#     FoodItemCompound.create(food_item_id: 2, compound_id: 7, amount_mg:200)
#     FoodItemCompound.create(food_item_id: 3, compound_id:1, amount_mg: 100)
#     FoodItemCompound.create(food_item_id: 3, compound_id:2, amount_mg:50)
#     FoodItemCompound.create(food_item_id: 4, compound_id:3, amount_mg:75)
#     FoodItemCompound.create(food_item_id: 4, compound_id:4, amount_mg:100)
#     FoodItemCompound.create(food_item_id: 4, compound_id:5, amount_mg:250)
#     FoodItemCompound.create(food_item_id: 5, compound_id:6, amount_mg:300)
#     FoodItemCompound.create(food_item_id: 6, compound_id:7, amount_mg: 210)
# end

def seed_users
    jamal = User.create(name: "Jamal Shareef", username: "Jshareef", password: "1234")
    kendall = User.create(name: "Kendall Shareef", username: "Kshareef", password: "1234")
    # jamal.meals.create([
    #     {date: Time.now},
    #     {date: Time.now},
    #     {date: Time.now},
    #     {date: Time.now - (60*60*24)},
    #     {date: Time.now - (60*60*24)},
    #     {date: Time.now - (60*60*24)},
    #     {date: Time.now - (2*60*60*24)},
    #     {date: Time.now - (2*60*60*24)},
    #     {date: Time.now - (2*60*60*24)}
    # ])
    end
    

# def seed_compounds
#     Compound.create(name: "protein", nutrient_id:1003, description: "Protein is necessary to build, maintain, and repair muscle.
#         Athletes must consider both protein quality and quantity to meet their needs for the nutrient. 
#         They must obtain essential amino acids (EAAs) from the diet or from supplementation to support muscle growth, maintenance, and repair. 
#         The nine EAAs are histidine, isoleucine, leucine, lysine, methionine, phenylalanine, threonine, tryptophan, and valine. 
#         Most complete proteins (those that contain all EAAs) are composed of about 40% EAAs, 
#         so a meal or snack with 25 g total protein provides about 10 g EAAs.", rdv_mg: 200000.0 )
#     Compound.create(name: "fiber, total dietary", nutrient_id:1079 , description:"for digestive", rdv_mg: 30000.0)
#     Compound.create(name: "calcium, ca", nutrient_id:1087, description:"The body needs calcium to maintain strong bones 
#         and to carry out many important functions. Almost all calcium is stored in bones and teeth, where it supports their structure and hardness.
#         The body also needs calcium for muscles to move and for nerves to carry messages between the brain and every body part. 
#         In addition, calcium is used to help blood vessels move blood throughout the body and to help release hormones and enzymes 
#         that affect almost every function in the human body.", rdv_mg: 1000.0)
#     Compound.create(name: "iron, fe", nutrient_id:1089, description:"Iron is a mineral that the body needs for growth and development. 
#         Your body uses iron to make hemoglobin, a protein in red blood cells that carries oxygen from the lungs to all parts of the body, 
#         and myoglobin, a protein that provides oxygen to muscles. 
#         Your body also needs iron to make some hormones and connective tissue.", rdv_mg: 15.0)
#     Compound.create(name: "magnesium, mg", nutrient_id:1090, description: "Magnesium is a nutrient that the body needs to stay healthy.
#          Magnesium is important for many processes in the body, including regulating muscle and nerve function, blood sugar levels, 
#          and blood pressure and making protein, bone, and DNA.", rdv_mg: 400.0)
#     Compound.create(name: "manganese, mn", nutrient_id:1101, description: "Manganese is a cofactor for many enzymes, 
#         including manganese superoxide dismutase, arginase, and pyruvate carboxylase. 
#         Through the action of these enzymes, manganese is involved in amino acid, cholesterol, glucose, and carbohydrate 
#         metabolism; reactive oxygen species scavenging; bone formation; reproduction; and immune response.
#          Manganese also plays a role in blood clotting and hemostasis in conjunction with vitamin K [5].", rdv_mg: 2.0)
#     Compound.create(name: "phosphorus, p", nutrient_id:1091, description:"The main function of phosphorus is in the formation 
#         of bones and teeth. It plays an important role in how the body uses carbohydrates and fats. 
#         It is also needed for the body to make protein for the growth, maintenance, and repair of cells and tissues. 
#         Phosphorus also helps the body make ATP, a molecule the body uses to store energy.
#         Phosphorus works with the B vitamins. It also helps with the following: Kidney function, Muscle contractions, Normal heartbeat
#         Nerve signaling", rdv_mg: 1000.0)
#     Compound.create(name: "potassium, k", nutrient_id:1092, description:"Your body needs potassium for almost everything it does, 
#         including proper kidney and heart function, muscle contraction, and nerve transmission.", rdv_mg: 4700.0)
#     Compound.create(name: "sodium, na", nutrient_id:1093, description:"Balances fluids in the body.Helps send nerve impulses.
#         Needed for muscle contractions. Influences blood pressure; even modest reductions in sodium consumption 
#         can lower blood pressure.", rdv_mg: 2300.0)
#     Compound.create(name: "zinc, zn", nutrient_id:1095, description: "Zinc is a nutrient that people need to stay healthy. 
#         Zinc is found in cells throughout the body. It helps the immune system fight off invading bacteria and viruses. 
#         The body also needs zinc to make proteins and DNA, the genetic material in all cells. During pregnancy, infancy, and childhood, 
#         the body needs zinc to grow and develop properly. 
#         Zinc also helps wounds heal and is important for proper senses of taste and smell.", rdv_mg: 10.0)
#     Compound.create(name: "copper, cu", nutrient_id:1098, description:"Copper works with iron to help the body form red blood cells.
#          It also helps keep the blood vessels, nerves, immune system, and bones healthy. Copper also aids in iron absorption.", rdv_mg: 0.9)
#     Compound.create(name: "selenium, se", nutrient_id:1103, description:"Selenium is important for reproduction, thyroid gland function, 
#         DNA production, and protecting the body from damage caused by free radicals and from infection.", rdv_mg: 0.055)
#     Compound.create(name: "vitamin a, iu", nutrient_id:1106, description:"Vitamin A is a fat-soluble vitamin that is naturally present in many foods. 
#         Vitamin A is important for normal vision, the immune system, and reproduction. Vitamin A also helps the heart, lungs, kidneys, 
#         and other organs work properly.There are two different types of vitamin A. The first type, preformed vitamin A, 
#         is found in meat, poultry, fish, and dairy products. The second type, provitamin A, is found in fruits, vegetables, 
#         and other plant-based products. The most common type of provitamin A in foods and dietary supplements is beta-carotene.", rdv_mg: 900.0)
#     Compound.create(name: "vitamin a, rae", nutrient_id:1106, description:"Vitamin A is a fat-soluble vitamin that is naturally present 
#         in many foods. Vitamin A is important for normal vision, the immune system, and reproduction. Vitamin A also helps the heart, 
#         lungs, kidneys, and other organs work properly. There are two different types of vitamin A. 
#         The first type, preformed vitamin A, is found in meat, poultry, fish, and dairy products. 
#         The second type, provitamin A, is found in fruits, vegetables, and other plant-based products. 
#         The most common type of provitamin A in foods and dietary supplements is beta-carotene.", rdv_mg: 900.0)
#     Compound.create(name: "vitamin e (alpha-tocopherol)", nutrient_id:1109, description:"Vitamin E is a fat-soluble nutrient 
#     found in many foods. In the body, it acts as an antioxidant, helping to protect cells from the damage caused by free radicals. 
#     Free radicals are compounds formed when our bodies convert the food we eat into energy. People are also exposed to free radicals 
#     in the environment from cigarette smoke, air pollution, and ultraviolet light from the sun.
#     The body also needs vitamin E to boost its immune system so that it can fight off invading bacteria and viruses. 
#     It helps to widen blood vessels and keep blood from clotting within them. 
#     In addition, cells use vitamin E to interact with each other and to carry out many important functions.", rdv_mg: 15.0)
#     Compound.create(name: "vitamin d (d2 + d3)", nutrient_id:1114, description:"Vitamin D is a nutrient found in some foods 
#     that is needed for health and to maintain strong bones. It does so by helping the body absorb calcium (one of bone’s main building blocks) 
#     from food and supplements. Vitamin D is important to the body in many other ways as well. Muscles need it to move, for example, 
#     nerves need it to carry messages between the brain and every body part, and the immune system needs vitamin D to fight off 
#     invading bacteria and viruses. Together with calcium, vitamin D also helps protect older adults from osteoporosis. 
#     Vitamin D is found in cells throughout the body.", rdv_mg: 600.0)
#     Compound.create(name: "vitamin c, ascorbic acid", nutrient_id:1162, description:"Vitamin C, also known as ascorbic acid, 
#         is a water-soluble nutrient found in some foods. In the body, it acts as an antioxidant, helping to protect cells from 
#         the damage caused by free radicals. Free radicals are compounds formed when our bodies convert the food we eat into energy.
#          People are also exposed to free radicals in the environment from cigarette smoke, air pollution, and ultraviolet light from the sun.
#         The body also needs vitamin C to make collagen, a protein required to help wounds heal. In addition, vitamin C improves the 
#         absorption of iron from plant-based foods and helps the immune system work properly to protect the body from disease.", rdv_mg: 90.0)
#     Compound.create(name: "thiamin", nutrient_id:1165, description:"Thiamin (also called vitamin B1) helps turn the food you eat 
#     into the energy you need. Thiamin is important for the growth, development, and function of the cells in your body.", rdv_mg: 1.2 )
#     Compound.create(name: "riboflavin", nutrient_id:1166, description:"Riboflavin (also known as vitamin B2) is one of the B vitamins, 
#     which are all water soluble. Riboflavin is naturally present in some foods, added to some food products, and available as a dietary supplement. 
#     This vitamin is an essential component of two major coenzymes, flavin mononucleotide (FMN; also known as riboflavin-5’-phosphate) and 
#     flavin adenine dinucleotide (FAD). These coenzymes play major roles in energy production; cellular function, growth, and development;
#      and metabolism of fats, drugs, and steroids [1-3]. The conversion of the amino acid tryptophan to niacin (sometimes referred to as vitamin B3) 
#      requires FAD [3]. Similarly, the conversion of vitamin B6 to the coenzyme pyridoxal 5’-phosphate needs FMN. In addition, 
#      riboflavin helps maintain normal levels of homocysteine, an amino acid in the blood [1].", rdv_mg: 1.3 )
#     Compound.create(name: "niacin", nutrient_id:1167, description:"Niacin (also known as vitamin B3) is one of the water-soluble B vitamins. 
#     Niacin is the generic name for nicotinic acid (pyridine-3-carboxylic acid), nicotinamide (niacinamide or pyridine-3-carboxamide), 
#     and related derivatives, such as nicotinamide riboside [1-3]. Niacin is naturally present in many foods, added to some food products,
#      and available as a dietary supplement.\n All tissues in the body convert absorbed niacin into its main metabolically active form, 
#      the coenzyme nicotinamide adenine dinucleotide (NAD). More than 400 enzymes require NAD to catalyze reactions in the body,
#       which is more than for any other vitamin-derived coenzyme [1]. NAD is also converted into another active form, 
#       the coenzyme nicotinamide adenine dinucleotide phosphate (NADP), in all tissues except skeletal muscle [4].", rdv_mg: 16.0 )
#     Compound.create(name: "vitamin b-5", nutrient_id:1170, description:"The main function of this water-soluble B vitamin is in the synthesis of 
#         coenzyme A (CoA) and acyl carrier protein. CoA is essential for fatty acid synthesis and degradation, 
#         transfer of acetyl and acyl groups, and a multitude of other anabolic and catabolic processes", rdv_mg: 5.0)
#     Compound.create(name: "vitamin b-6", nutrient_id:1175, description:"Vitamin B6 is a vitamin that is naturally present in many foods. 
#         The body needs vitamin B6 for more than 100 enzyme reactions involved in metabolism. 
#         Vitamin B6 is also involved in brain development during pregnancy and infancy as well as immune function.", rdv_mg: 1.3)
#     Compound.create(name: "vitamin b12", nutrient_id:1178, description:"Vitamin B12 is a nutrient that helps 
#         keep the body’s nerve and blood cells healthy and helps make DNA, the genetic material in all cells. 
#         Vitamin B12 also helps prevent a type of anemia called megaloblastic anemia that makes people tired and weak.", rdv_mg: 0.0024)
#     Compound.create(name: "choline", nutrient_id:1180, description:"Choline is a nutrient that is found in many foods. 
#         Your brain and nervous system need it to regulate memory, mood, muscle control, and other functions. 
#         You also need choline to form the membranes that surround your body’s cells. You can make a small 
#         amount of choline in your liver, but most of the choline in your body comes from the food you eat.", rdv_mg: 550)
#     Compound.create(name: "vitamin k (phylloquinone)", nutrient_id:1185, description:"Vitamin K is a nutrient that the body 
#     needs to stay healthy. It’s important for blood clotting and healthy bones and also has other functions in the body. 
#     If you are taking a blood thinner such as warfarin (Coumadin®), it’s very important to get about the 
#     same amount of vitamin K each day.", rdv_mg: 120 )
#     Compound.create(name: "folate, total", nutrient_id:1177, description:"Folate is a B-vitamin that
#          is naturally present in many foods. Your body needs folate to make DNA and other genetic material. 
#          Your body also needs folate for your cells to divide. A form of folate, called folic acid, 
#          is used in fortified foods and most dietary supplements.", rdv_mg: 0.4)
# end




# def seed_meal_food_items
#     MealFoodItem.create(meal_id:1, food_item_id:1)
#     MealFoodItem.create(meal_id:1, food_item_id:2)
#     MealFoodItem.create(meal_id:1, food_item_id:3)
#     MealFoodItem.create(meal_id:1, food_item_id:4)
#     MealFoodItem.create(meal_id:1, food_item_id:3)
#     MealFoodItem.create(meal_id:1, food_item_id:6)
#     MealFoodItem.create(meal_id:2, food_item_id:5)
#     MealFoodItem.create(meal_id:2, food_item_id:2)
#     MealFoodItem.create(meal_id:2, food_item_id:3)
#     MealFoodItem.create(meal_id:2, food_item_id:1)
#     MealFoodItem.create(meal_id:2, food_item_id:2)
#     MealFoodItem.create(meal_id:2, food_item_id:4)
#     MealFoodItem.create(meal_id:3, food_item_id:4)
#     MealFoodItem.create(meal_id:3, food_item_id:5)
#     MealFoodItem.create(meal_id:3, food_item_id:3)
#     MealFoodItem.create(meal_id:3, food_item_id:2)
#     MealFoodItem.create(meal_id:3, food_item_id:1)
#     MealFoodItem.create(meal_id:3, food_item_id:1)
#     MealFoodItem.create(meal_id:4, food_item_id:5)
#     MealFoodItem.create(meal_id:4, food_item_id:2)
#     MealFoodItem.create(meal_id:4, food_item_id:3)
#     MealFoodItem.create(meal_id:4, food_item_id:1)
#     MealFoodItem.create(meal_id:4, food_item_id:2)
#     MealFoodItem.create(meal_id:4, food_item_id:4)
#     MealFoodItem.create(meal_id:5, food_item_id:4)
#     MealFoodItem.create(meal_id:5, food_item_id:5)
#     MealFoodItem.create(meal_id:5, food_item_id:3)
#     MealFoodItem.create(meal_id:5, food_item_id:2)
#     MealFoodItem.create(meal_id:5, food_item_id:1)
#     MealFoodItem.create(meal_id:6, food_item_id:1)
# end


seed_compounds
seed_food_items
seed_food_item_compounds
seed_users
# sead_meals
# seed_meal_food_items






