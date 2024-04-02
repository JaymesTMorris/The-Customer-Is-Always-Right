extends Node

signal new_grill_item(grill_name)
signal grill_item_removed(grill_name)

# Called when the node enters the scene tree for the first time.
func _ready():
	connect("new_grill_item", item_added_to_grill)
	connect("grill_item_removed", item_removed_from_grill)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func item_added_to_grill(grill_name):
	_start_cooking_timer(grill_name)
	global.items_on_grill += 1

func item_removed_from_grill(grill_name):
	print(grill_name + "_Timer")
	find_child(grill_name + "_Timer", true, false).stop()
	if global.items_on_grill > 0:
		global.items_on_grill -= 1

func _on_timer_timeout(grill_name):
	var grill = get_parent().find_child(grill_name, true, false)
	var food_in_grill
	if grill.find_child("Icon").texture != null:
		food_in_grill = grill.find_child("Icon").texture.resource_path.get_file().get_basename()
		if food_in_grill == "RawBeefPatty":
			grill.find_child("Icon").texture = load("res://Images/Food/NewSprites/HalfCookedBeefPatty.png")
		elif food_in_grill == "HalfCookedBeefPatty":
			grill.find_child("Icon").texture = load("res://Images/Food/NewSprites/BeefPatty.png")
		elif food_in_grill == "BeefPatty":
			grill.find_child("Icon").texture = load("res://Images/Food/NewSprites/BurntBeefPatty.png")
		else:
			grill.find_child("Icon").texture = load("res://Images/Food/NewSprites/Ashes.png")

func _start_cooking_timer(grill_name):
	if find_child(grill_name + "_Timer") == null:
		var timer = Timer.new()
		add_child(timer)
		timer.name = grill_name + "_Timer"
		timer.wait_time = 3
		timer.one_shot = false
		timer.start()
		timer.connect("timeout", func(): _on_timer_timeout(grill_name))
	else:
		find_child(grill_name + "_Timer").start()
	
