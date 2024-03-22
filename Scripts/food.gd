extends Node2D

var draggable:bool = false
var is_inside_dropable: bool = false
var is_cloneable:bool = true

var food_prefab_path: String
var body_ref
var offset: Vector2
var initial_position: Vector2

func _ready():
	initial_position = position
	food_prefab_path = scene_file_path

func _process(delta):
	if draggable:
		if Input.is_action_just_pressed("click"):
			if is_cloneable:
				_create_clone()
				is_cloneable = false
			offset = get_global_mouse_position() - global_position
			global.is_dragging = true
		if Input.is_action_pressed("click"):
			global_position = get_global_mouse_position() - offset
		elif Input.is_action_just_released("click"):
			global.is_dragging = false
			var tween = get_tree().create_tween()
			if is_inside_dropable:
				if body_ref.is_in_group("trash"):
					queue_free()
				tween.tween_property(self, "position", body_ref.position, 0.2).set_ease(Tween.EASE_OUT)
			else:
				tween.tween_property(self, "global_position", initial_position, 0.2).set_ease(Tween.EASE_OUT)
				tween.connect("finished", queue_free)

func _on_area_2d_mouse_entered():
	if not global.is_dragging:
		draggable = true
		scale = Vector2(1.05, 1.05)

func _on_area_2d_mouse_exited():
	if not global.is_dragging:
		draggable = false
		scale = Vector2(1,1)

func _on_area_2d_body_entered(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = true
		body.modulate = Color(Color.REBECCA_PURPLE, 1)
		body_ref = body

func _on_area_2d_body_exited(body):
	if body.is_in_group("dropable"):
		is_inside_dropable = false
		body.modulate = Color(Color.MEDIUM_PURPLE, 0.7)
		
func _create_clone():
	var node = load(food_prefab_path)
	var instance = node.instantiate()
	instance.position = body_ref.position
	instance.initial_position = body_ref.position
	add_sibling(instance)
	
