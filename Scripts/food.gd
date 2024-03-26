extends Node2D

var draggable:bool = false
var is_inside_dropable: bool = false
var is_origin:bool = true # Is the original item/not a clone

var food_prefab_path: String
var body_ref # Item slot being hovered over
var clone # Cloned object
var offset: Vector2
var initial_position: Vector2

func _ready():
	initial_position = position
	food_prefab_path = scene_file_path

func _process(delta): # _process is called every frame
	if draggable:
		if Input.is_action_just_pressed("click"):
			#print(name)
			if is_origin:
				draggable = false
				clone = _create_clone()
				offset = get_global_mouse_position() - clone.global_position
				
			else:
				offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			if is_origin:
				clone.global_position = get_global_mouse_position() - clone.offset
			else:
				global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_origin:
				if clone.is_inside_dropable:
					if clone.body_ref.is_in_group("trash"):
						clone.queue_free()
					tween.tween_property(clone, "position", clone.body_ref.position, 0.1).set_ease(Tween.EASE_OUT)
				else:
					tween.tween_property(clone, "global_position", clone.initial_position, 0.1).set_ease(Tween.EASE_OUT)
					tween.connect("finished", clone.queue_free)
			else:
				if is_inside_dropable:
					if body_ref.is_in_group("trash"):
						queue_free()
					tween.tween_property(self, "position", body_ref.position, 0.1).set_ease(Tween.EASE_OUT)
				else:
					tween.tween_property(self, "global_position", initial_position, 0.1).set_ease(Tween.EASE_OUT)
					tween.connect("finished", queue_free)

func _on_area_2d_mouse_entered(): # When mouse starts hovering over a food item
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)
		$Sprite2D.material.set_shader_parameter("enabled", true)

func _on_area_2d_mouse_exited(): # When mouse stops hovering over a food item
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1,1)
		$Sprite2D.material.set_shader_parameter("enabled", false)

func _on_area_2d_body_entered(body): # Dragged item is hovering over a 2d body (i.e. an item slot)
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body

func _on_area_2d_body_exited(body): # Dragged item is no longer hovering over a 2d body (i.e. an item slot)
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
		
func _create_clone():
	var node = load(food_prefab_path)
	var instance = node.instantiate()
	instance.position = initial_position
	instance.initial_position = initial_position
	instance.is_origin = false
	instance.draggable = true
	add_sibling(instance)
	return instance
	
