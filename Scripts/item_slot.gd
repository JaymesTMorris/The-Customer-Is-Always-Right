class_name ItemSlot extends StaticBody2D

@export var items_in_slot = []

func _ready():
	modulate = Color(Color.MEDIUM_PURPLE, 0.7)

func _process(delta):
	update_visibility()

func update_visibility():
	if global.is_dragging:
		visible = true
	else:
		visible = false
