extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.action_points = 5
	Global.day = 0
	Global.set_quota_count(Global.ProduceType.BERRY, 5)
	Global.set_produce_count(Global.ProduceType.BERRY, 2)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_hud_action_changed(newAction, plantType):
	pass # Replace with function body.
	
func _on_turn_end(): 
	$GardenTiles.tick()
	Global.day += 1
