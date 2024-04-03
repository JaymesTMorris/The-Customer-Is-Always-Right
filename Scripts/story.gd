extends Control

# Setup
var player
var dialogue = [
	"After enduring endless years of slaving away as an underappreciated diner chef, I've finally \
mustered the courage to hand in my two-weeks notice. With this newfound liberation, I relish the \
opportunity to enact revenge on the petty regulars who've tormented me with their incessant \
complaints and stinginess.",
	"These next two weeks serve as my canvas for mischief, where I take pleasure in concealing \
diabolical surprises within their meals, each act a sweet retaliation for the years of disrespect \
and ingratitude endured behind the kitchen doors.",
	"Now then... should I give them and raw burger? Hmmmm... or... perhaps a burger with ashes and posion ivy?",
]
var current_dialogue = 0

# Initialization
func _ready():
	player = get_node("/root/player")
	start_story()

func start_story():
	get_node("StoryOutput/Next").disabled = true
	if player.gender == 0:
		get_node("Chef").texture = load("res://Images/Chef_00.jpg")
	elif player.gender == 1:
		get_node("Chef").texture = load("res://Images/Chef_01.jpg")
	_print_message()
	audio_player.play_sfx(audio_player.talking_sfx, -10.0)

func _next_dialogue():
	get_node("StoryOutput/Next").disabled = true
	audio_player.play_sfx(audio_player.button_click_sfx, -10.0)
	current_dialogue += 1
	if current_dialogue < dialogue.size():
		get_node("StoryOutput").text = ""
		_print_message()
		if current_dialogue == dialogue.size() - 1:
			get_node("StoryOutput/Next").hide()
			get_node("StoryOutput/Continue").show()
	audio_player.play_sfx(audio_player.talking_sfx)

func _on_continue_pressed():
	audio_player.play_sfx(audio_player.button_click_sfx)
	get_tree().change_scene_to_file("res://Scenes/game_remake.tscn")


func _on_button_mouse_entered():
	audio_player.play_sfx(audio_player.button_hover_sfx)
	
func _print_message():
	for char in dialogue[current_dialogue]:
		get_node("StoryOutput").text += char
		await _wait(0.01)
	get_node("StoryOutput/Next").disabled = false

func _wait(duration):  
	await get_tree().create_timer(duration, false, false, true).timeout
