extends AudioStreamPlayer2D

const menu_music = preload("res://Sounds/654727__sergequadrado__deep-epic.wav")
const game_music = preload("res://Sounds/325611__shadydave__my-love-piano-loop.mp3")
const game_background_sounds = preload("res://Sounds/90202__greg-baumont__restaurantinparispart2.mp3")
const button_hover_sfx = preload("res://Sounds/26777__junggle__btn402.mp3")
const button_click_sfx = preload("res://Sounds/245645__unfa__cartoon-pop-clean.mp3")
const sizzling_sfx = preload("res://Sounds/85468__jasonelrod__sizzling.mp3")
const talking_sfx = preload("res://Sounds/184447__nickreffin__cartoon-phone-voice.wav")



var is_music_loop = true

func _play_music(music: AudioStream, volume = 0.0):
	if stream == music:
		return
	stream = music
	volume_db = volume
	if is_music_loop:
		connect("finished", play)
	play()
	
func play_menu_music():
	_play_music(menu_music)
	
func play_game_music():
	_play_music(game_music)
	play_sfx(game_background_sounds, -20.0, true)

func play_sfx(sfx: AudioStream, volume = 0.0, is_sfx_loop = false):
	var sfx_player = AudioStreamPlayer.new()
	sfx_player.stream = sfx
	sfx_player.name = "SFX_Player"
	sfx_player.volume_db = volume
	if is_sfx_loop:
		connect("finished", Callable(sfx_player, "play"))
	add_child(sfx_player)
	sfx_player.play()
	if not is_sfx_loop:
		await sfx_player.finished
		sfx_player.queue_free()

func ready_sizzle_sfx_player():
	var sizzle_sfx_player = AudioStreamPlayer.new()
	sizzle_sfx_player.stream = sizzling_sfx
	sizzle_sfx_player.name = "Sizzle_SFX_Player"
	sizzle_sfx_player.volume_db = 0.0
	add_child(sizzle_sfx_player)

func _ready():
	ready_sizzle_sfx_player()
	
func _process(delta):
	if (global.items_on_grill > 0) && not $Sizzle_SFX_Player.playing:
		$Sizzle_SFX_Player.play()
	elif global.items_on_grill == 0:
		$Sizzle_SFX_Player.stop()
