class_name ItemSlot extends StaticBody2D

var items_in_slot = []
var burger_order:Array = []

func _ready():
	modulate = Color(Color.MEDIUM_PURPLE, 0.45)

func _process(delta):
	update_visibility()

func update_visibility():
	if global.is_dragging:
		visible = true
	else:
		visible = false
