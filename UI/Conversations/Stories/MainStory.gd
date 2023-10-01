extends Node

var was_punched = false

@onready var test_convo = Conversation.new()
@onready var test_convo_ouch = Conversation.new()

@onready var test_convo2 = Conversation.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	test_convo.is_triggered = func():
		return Global.day == 3
	test_convo.script([
		{
			text = "Hi there, I hope you're settling in well.",
			image = "GodotFace",
			name = "Mr. Godot",
		},
		{
			text = "Now get back to work!",
		}
	])
	test_convo.choice_text = "Punch him in the face?"
	test_convo.choice = func(answer: bool):
		was_punched = answer
		Story.active_set.append(test_convo2)
	test_convo.yes_script([
		{
			text = "Ouch, you'll pay for that!",
			image = "GodotFace",
			name = "Mr. Godot",
		}
	])
	test_convo.no_script([
		{
			text = "Thank you.",
			image = "GodotFace",
			name = "Mr. Godot",
		}
	])
	
	test_convo2.script([
		{
			when = func(): return was_punched,
			text = "[i]He noticably has a black eye, and looks very angry[/i]",
		},
		{
			text = "Product please.",
			image = "GodotFace",
			name = "Mr. Godot",
			callback = func(): pass
		}
	])
	
	Story.active_set.push_back(test_convo)

func take_quota(convo : Conversation):
	pass
