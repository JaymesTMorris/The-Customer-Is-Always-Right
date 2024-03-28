extends Node2D


# Variables
var is_draggable:bool = false
var is_inside_dropable: bool = false
var is_not_a_clone:bool = true
var is_plated_child:bool = false # Is plated and a child of another food.
var is_plated_parent:bool = false # Is plated and parent of all food on plate.

var food_prefab_path: String
var hovered_item_slot: Object
var clone: Object
var mouse_offset: Vector2
var initial_position: Vector2

# Initialization
func _ready():
	initial_position = position
	food_prefab_path = scene_file_path

# _process is called every frame
func _process(delta):
	handle_dragging()

func handle_dragging():
	if is_draggable:
		if Input.is_action_just_pressed("click"):
			start_dragging()
		if Input.is_action_pressed("click"):
			drag()
		elif Input.is_action_just_released("click"):
			stop_dragging()

func start_dragging():
	if is_plated_parent:
		hovered_item_slot.items_in_slot = []
		queue_free()
		return
	elif is_plated_child:
		if hovered_item_slot.items_in_slot.size() != 0:
			var plated_parent = hovered_item_slot.items_in_slot[0]
			hovered_item_slot.items_in_slot = []
			plated_parent.queue_free()
			return
	elif is_not_a_clone:
		is_draggable = false
		clone = _create_clone()
		mouse_offset = get_global_mouse_position() - clone.global_position
		global.is_dragging = true
	else:
		hovered_item_slot.items_in_slot = []
		mouse_offset = get_global_mouse_position() - global_position
		global.is_dragging = true

func drag():
	if not is_not_a_clone: # If this is a clone
		global_position = get_global_mouse_position() - mouse_offset

func stop_dragging():
	var tween = get_tree().create_tween()
	if not is_not_a_clone: # If this is a clone
		if is_inside_dropable:
			if hovered_item_slot.is_in_group("trash"):
				queue_free()
				global.is_dragging = false
			tween.tween_property(self, "position", hovered_item_slot.position, 0.1).set_ease(Tween.EASE_OUT)
			tween.connect("finished", tween_finished)
		else:
			tween.tween_property(self, "global_position", initial_position, 0.1).set_ease(Tween.EASE_OUT)
			tween.connect("finished", func(): tween_finished(true))

func tween_finished(delete:bool = false):
	is_draggable = false
	global.is_dragging = false
	if delete:
		queue_free()
	else:
		place_in_slot()

func place_in_slot():
	if hovered_item_slot.is_in_group("plate"):
		if hovered_item_slot.items_in_slot.size() < 6:
			hovered_item_slot.items_in_slot.append(self)
			offset_ingredients()
		else:
			queue_free()
	else: #If it is not being placed on a plate
		if hovered_item_slot.items_in_slot.size() == 0:
			hovered_item_slot.items_in_slot.append(self)
		else:
			if not hovered_item_slot.items_in_slot[0] == self:
				queue_free()

func offset_ingredients():
	var ingredients = hovered_item_slot.items_in_slot
	for index in ingredients.size():
		if index == 0:
			ingredients[index].is_plated_parent = true
		else:
			ingredients[index].reparent(ingredients[index-1])
			ingredients[index].is_plated_child = true
			ingredients[index].global_position.y = hovered_item_slot.global_position.y - (10 * index)
	#ingredients[0].global_position.y = hovered_item_slot.global_position.y - (10 * ingredients.size())

func _on_area_2d_mouse_entered(): # When mouse starts hovering over a food item
	if not global.is_dragging:
		is_draggable = true
		if not is_plated_child:
			scale = Vector2(2.2, 2.2)
		elif hovered_item_slot.items_in_slot.size() != 0:
			hovered_item_slot.items_in_slot[0].scale = Vector2(2.2, 2.2)
		$Sprite2D.material.set_shader_parameter("enabled", true)

func _on_area_2d_mouse_exited(): # When mouse stops hovering over a food item
	if not global.is_dragging:
		is_draggable = false
		if not is_plated_child:
			scale = Vector2(2, 2)
		elif hovered_item_slot.items_in_slot.size() != 0:
			hovered_item_slot.items_in_slot[0].scale = Vector2(2, 2)
		$Sprite2D.material.set_shader_parameter("enabled", false)

func _on_area_2d_body_entered(body): # Dragged item is hovering over a 2d body (i.e. an item slot)
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 0.6)
		hovered_item_slot = body

func _on_area_2d_body_exited(body): # Dragged item is no longer hovering over a 2d body (i.e. an item slot)
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.45)
		
func _create_clone():
	# Initialize Clone
	var node = load(food_prefab_path)
	var instance = node.instantiate()
	# Setup clone
	instance.position = initial_position
	instance.initial_position = initial_position
	instance.is_not_a_clone = false
	instance.is_draggable = true
	# Spawn Clone
	add_sibling(instance)
	return instance
	
