extends VideoStreamPlayer

func _ready():
	connect("finished", _on_VideoPlayer_finished)

func _on_VideoPlayer_finished():
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
