extends Node

var map_data = {\
"Grill1": [],
"Grill2": [],
"Grill3": [],
"Grill4": [],
"Plate1": [],
"Plate2": [],
"Plate3": [],
"Plate4": [],
"Plate1_Order": [],
"Plate2_Order": [],
"Plate3_Order": [],
"Plate4_Order": []}

var is_dragging = false
var score = 0
var items_on_grill: int = 0

var is_something_cooking_on_grill0
var is_something_cooking_on_grill1
var is_something_cooking_on_grill2
var is_something_cooking_on_grill3
