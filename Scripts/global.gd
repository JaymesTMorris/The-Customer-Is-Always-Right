extends Node

var map_data = {\
"Grill1": [],
"Grill2": [],
"Grill3": [],
"Grill4": [],
"Plate1": [],
"Plate2": [],
"Plate3": [],
"Plate4": []}

var is_dragging = false
var score = 0
var is_something_cooking = false
var is_something_cooking_on_grill0 = false
var is_something_cooking_on_grill1 = false
var is_something_cooking_on_grill2 = false
var is_something_cooking_on_grill3 = false

func _process(delta):
	if is_something_cooking_on_grill0 || is_something_cooking_on_grill1 || is_something_cooking_on_grill2 || is_something_cooking_on_grill3:
		is_something_cooking = true
	else:
		is_something_cooking = false
