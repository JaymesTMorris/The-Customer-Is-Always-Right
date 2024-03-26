extends Node2D


var ingredients : Dictionary = {
	1 : "Patty" ,
	2 : "Lettuce",
	3 : "Pickles",
	4 : "Tomato",
	5 : "Cheese",
	6 : "Chicken"
	
}
var bad_ingredients : Dictionary = {
	1 : "Moldy bread",
	2 : "Old Gum",
	3 : "Latex Glove",
	4 : "Bones"
}

func _ready():
	$Label.text = generate()

func generate():
	var order : Dictionary = {}
	var ingredient_one = ingredients.get(1)
	var ingredient_two = ingredients.get(randi_range(1, ingredients.size()))
	while ingredient_two == ingredient_one:
		ingredient_two = ingredients.get(randi_range(1, ingredients.size()))
	var ingredient_three = ingredients.get(randi_range(1, ingredients.size()))
	while ingredient_three == ingredient_one || ingredient_three == ingredient_two:
		ingredient_three = ingredients.get(randi_range(1, ingredients.size()))
	var bad_ingredient = bad_ingredients.get(randi_range(1, bad_ingredients.size()))
	return(ingredient_one + ", " + ingredient_two + ", " + ingredient_three +", and "+bad_ingredient)

