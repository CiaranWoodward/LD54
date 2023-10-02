extends Node

var active_set : Array[Conversation] = []

var bootlicker = 0
var failure = 0
var success = 0
var snitch = 0
var subtle = 0
var good_neighbor = 0
var fool = 0
var written_up = 0
var complete = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func tick_story(dialogue_scene):
	active_set.sort_custom(func(a : Conversation, b : Conversation): return a.priority > b.priority)
	var aset_copy = active_set
	for convo in aset_copy:
		if convo.is_triggered.call():
			active_set.erase(convo)
			await dialogue_scene.run_conversation(convo)
