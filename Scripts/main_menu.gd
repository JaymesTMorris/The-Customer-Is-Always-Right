extends Control

func _ready():
	audio_player.play_menu_music()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://Scenes/character_selection.tscn")

func _on_options_pressed():
	pass # Replace with function body.

func _on_quit_pressed():
	get_tree().quit()


func _on_button_mouse_entered():
	audio_player.play_sfx(audio_player.button_hover_sfx)
	audio_player.ready_sizzle_sfx_player()
	
func _on_button_pressed():
	audio_player.play_sfx(audio_player.button_click_sfx)
