extends Node

var is_timer_running = false
var timer_duration
var time_left

# Called when the node enters the scene tree for the first time.
func _ready():
	set_timer(5)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	update_timer(delta)

func set_timer(seconds):
	timer_duration = seconds
	time_left = timer_duration
	is_timer_running = true
	print("Timer Set! Set for ", seconds, "seconds!")

func update_timer(delta):
	if is_timer_running:
		if time_left > 0:
			time_left -= delta
			#print(time_left)
		else:
			is_timer_running = false
			print("Timer Finished!")
