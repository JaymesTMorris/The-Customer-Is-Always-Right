extends Node

var burger_ingredients: Array = [
	["Cooked Patty", "beef_patty.tscn"],
	["Bottom Bun", "bun_bottom.tscn"],
	["Top Bun", "bun_top.tscn"],
	["Cheese", "cheese.tscn"],
	["Lettuce", "lettuce.tscn"],
	["Tomato", "tomato.tscn"]
]

# Currently not in use.
var bad_burger_ingredients: Array = [
	["Moldy Bread", "moldy_bread.tscn"],
	["Poison Ivy", "poison_ivy.tscn"]
]

func generate_burger_order(is_good_customer: bool = true):
	var burger_order = ["Top Bun"] # Burger orders will always have a Top Bun
	var good_ingredients = generate_good_burger_ingredients() # Returns 0 - 2 good ingredients
	var bad_ingredients = generate_bad_burger_ingredients() # Returns 1 bad ingredient
	
	burger_order.append_array(good_ingredients)
	if not is_good_customer:
		burger_order.append_array(bad_ingredients) 
	burger_order.append("Cooked Patty") # Burger orders will always have a Cooked Patty
	burger_order.append("Bottom Bun") # Burger orders will always have a Bottom Bun
	
	return burger_order

func generate_good_burger_ingredients():
	var good_ingredients = []
	var current_ingredients_on_burger = 3 # Burgers are always have 2 buns and 1 patty
	
	if randi() % 2 == 0: # 50% for burger to have Tomato
		good_ingredients.append("Tomato")
		current_ingredients_on_burger += 1
	if randi() % 2 == 0: # 50% for burger to have Lettuce
		good_ingredients.append("Lettuce")
		current_ingredients_on_burger += 1
	if randi() % 2 == 0 && current_ingredients_on_burger < 5: # 50% for burger to have Cheese
		good_ingredients.append("Cheese")
		current_ingredients_on_burger += 1
	if randi() % 2 == 0 && current_ingredients_on_burger < 5: # 50% for burger to have Cheese (or extra cheese)
		good_ingredients.append("Cheese")
		current_ingredients_on_burger += 1
	print()
		
	return good_ingredients

func generate_bad_burger_ingredients():
	var bad_ingredients = []
	
	# 50% for burger to have Moldy Bread or Poison Ivy
	if randi() % 2 == 0: 
		bad_ingredients.append("Moldy Bread")
	else:
		bad_ingredients.append("Poison Ivy")
		
	return bad_ingredients

func print_order(order, label_name):
	get_parent().get_node(label_name).text = ""
	for i in order.size():
		get_parent().get_node(label_name).text += order[i]
		get_parent().get_node(label_name).text += "\n"

func _on_serve_button_down(button_pressed: int):
	var burger_order
	var plate
	
	burger_order = generate_burger_order()
	if button_pressed == 0:
		print_order(burger_order, "OrderLabel0")
		plate = get_parent().get_node("Plate0")
	elif button_pressed == 1:
		print_order(burger_order, "OrderLabel1")
		plate = get_parent().get_node("Plate1")
	elif button_pressed == 2:
		print_order(burger_order, "OrderLabel2")
		plate = get_parent().get_node("Plate2")
	elif button_pressed == 3:
		print_order(burger_order, "OrderLabel3")
		plate = get_parent().get_node("Plate3")
	print("Burger Order: ", plate.burger_order)
	print("Submitted Items: ", get_plate_as_array(plate))
	grade_order(get_plate_as_array(plate), plate.burger_order)
	clear_plate(plate)
	plate.burger_order = burger_order

func _ready():
	var i = 0
	var burger_order
	var plate
	while i <= 3:
		plate = get_parent().get_node(NodePath("Plate"+str(i)))
		burger_order = generate_burger_order()
		plate.burger_order = burger_order
		print_order(burger_order, NodePath("OrderLabel"+str(i)))
		
		i+=1

func grade_order(plate_array, burger_order):
	if plate_array == burger_order:
		global.score += 10
	elif global.score - 5 >= 0:
		global.score -= 5
	update_score_label()

func update_score_label():
	var score_label = get_tree().get_root().find_child("ScoreLabel",true,false)
	score_label.text = "[center]"+str(global.score)+"[/center]"

func get_plate_as_array(plate):
	var plate_array = []
	for plated_ingredient in plate.items_in_slot.size():
		var ingredient_on_plate = get_tree().get_root().find_child(NodePath(plate.items_in_slot[plated_ingredient].name),true,false)
		for burger_ingredient in burger_ingredients.size():
			if burger_ingredients[burger_ingredient][1] == ingredient_on_plate.food_prefab_path.get_file():
				plate_array.append(burger_ingredients[burger_ingredient][0])
				break
	plate_array.reverse()
	return plate_array

func clear_plate(plate):
	for i in plate.items_in_slot.size():
		var ingredient_on_plate = get_parent().get_node(NodePath(plate.items_in_slot[i].name))
		if ingredient_on_plate != null:
			ingredient_on_plate.queue_free()
	plate.items_in_slot = []

#var ingredients : Dictionary = {
	## ID : Ingredient Name
	#1 : "Patty" ,
	#2 : "Lettuce",
	#3 : "Pickles",
	#4 : "Tomato",
	#5 : "Cheese",
	#6 : "Chicken"
	#
#}
#var bad_ingredients : Dictionary = {
	#1 : "Moldy bread",
	#2 : "Old Gum",
	#3 : "Latex Glove",
	#4 : "Bones"
#}
#
#func _ready():
	#$Label.text = str(generate())
#
#func generate():
	#var order : Array = []
	#var ingredient_one = ingredients.get(1)
	#var ingredient_two = ingredients.get(randi_range(1, ingredients.size()))
	#while ingredient_two == ingredient_one:
		#ingredient_two = ingredients.get(randi_range(1, ingredients.size()))
	#var ingredient_three = ingredients.get(randi_range(1, ingredients.size()))
	#while (ingredient_three == ingredient_one) || (ingredient_three == ingredient_two):
		#ingredient_three = ingredients.get(randi_range(1, ingredients.size()))
	#var bad_ingredient = bad_ingredients.get(randi_range(1, bad_ingredients.size()))
	#order.append(ingredient_one)
	#order.append(ingredient_two)
	#order.append(ingredient_three)
	#order.append(bad_ingredient)
	#return(order)

