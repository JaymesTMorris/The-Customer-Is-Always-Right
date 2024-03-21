extends Control

# Setup
var player
var dialogue = [
	"As a Chef, I once believed in the sanctity of culinary artistry, pouring my heart and soul into\
 every dish I created. But oh, how things changed when I stumbled upon the chaos that unfolded \
behind the kitchen doors. Day in and day out, I toiled away in a bustling restaurant, striving \
to please the ungrateful masses who paraded through our doors.",
	"At first, I endured the occasional rude remark or unreasonable request with a forced smile, \
convinced that customer satisfaction was the highest priority. Yet, as time wore on, the \
disrespect and ingratitude of our patrons began to wear me down like a dull knife on a stubborn \
root vegetable.",
	"It wasn't long before I reached my breaking point, my once pristine apron now stained with the \
remnants of my shattered culinary dreams. I couldn't take it anymore—the entitled demands, the \
condescending remarks, the utter lack of appreciation for my craft.",
	"And so, fueled by a simmering resentment that bubbled over like a pot left unattended, I made a\
 decision that would forever change the course of my culinary career. No longer would I slave \
away to please the ungrateful masses. Instead, I would take matters into my own hands, quite \
literally, and serve up a taste of their own medicine.",
	"With a devilish grin and a twinkle in my eye, I began to concoct the most diabolical creations \
ever to grace a plate. From nauseatingly overcooked meats to bizarre flavor combinations that \
defied all reason, each dish was a testament to my newfound rebellion against the tyranny of \
entitled customers.",
	"And oh, the satisfaction I felt as I watched their expressions twist into grotesque contortions\
 upon taking their first bite! Gone were the haughty demands and entitled expectations, replaced\
 by a chorus of retching and gagging that echoed through the dining room like music to my \
ears.",
	"In the end, I suppose you could say that I became the monster lurking within the kitchen's \
shadows—a petty chef with a penchant for culinary chaos, serving up revenge, one repulsive dish \
at a time. And as long as there are rude customers to be found, I'll be there, waiting to \
unleash my gastronomic vengeance upon their unsuspecting taste buds. Bon appétit, indeed."
]
var current_dialogue = 0

# Initialization
func _ready():
	player = get_node("/root/Player")
	start_story()

func start_story():
	if player.gender == 0:
		get_node("Chef").texture = load("res://Images/Chef_00.jpg")
	elif player.gender == 1:
		get_node("Chef").texture = load("res://Images/Chef_01.jpg")
	get_node("StoryOutput").text = dialogue[current_dialogue]

func _next_dialogue():
	current_dialogue += 1
	if current_dialogue < dialogue.size():
		get_node("StoryOutput").text = "[center]"
		get_node("StoryOutput").text += dialogue[current_dialogue]
		get_node("StoryOutput").text += "[/center]"
		if current_dialogue == dialogue.size() - 1:
			get_node("StoryOutput/Next").hide()
			get_node("StoryOutput/Continue").show()

func _on_continue_pressed():
	pass # Replace with function body.
