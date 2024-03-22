extends Control

# Setup
var player

# Initialization
func _ready():
	player = get_node("/root/player")

# On Button Hover
func _on_button_0_mouse_entered():
	get_node("Chef0").show()


func _on_button_0_mouse_exited():
	get_node("Chef0").hide()


func _on_button_1_mouse_entered():
	get_node("Chef1").show()


func _on_button_1_mouse_exited():
	get_node("Chef1").hide()

# On Button CLick
func _on_button_0_pressed(): # Male Chef
	on_character_selected(0)


func _on_button_1_pressed(): # Female Chef
	on_character_selected(1)

# Other
func on_character_selected(gender):
	if gender == 0:
		print(player.gender)
		player.gender = 0
	elif gender == 1:
		player.gender = 1
	get_tree().change_scene_to_file("res://Scenes/story.tscn")
