extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hud_action_changed(newAction, plantType):
	pass # Replace with function body.
	
func _on_turn_end(): 
	emit_signal("turn_end")
