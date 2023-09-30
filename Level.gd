extends Node2D

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.action_points = 5
	$Cursor.clear_action_func = $HUD.clear_action
	Global.day = 0
	Global.set_quota_count(Global.ProduceType.BERRY, 5)
	Global.set_produce_count(Global.ProduceType.BERRY, 2)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var mtile = get_plant_tile_at_pos(get_local_mouse_position())
	$Cursor.set_current_tile(mtile)

func get_plant_tile(coords : Vector2i):
	return $GardenTiles.get_plant_tile(coords)

func get_plant_tile_at_pos(pos : Vector2):
	return $GardenTiles.get_plant_tile_at_pos(pos)

func _on_hud_action_changed(newAction, plantType):
	$Cursor.change_action(newAction, plantType)
	if newAction == Global.ActionType.END_TURN:
		_on_turn_end()
	
func _on_turn_end(): 
	$HUD.clear_action()
	$GardenTiles.tick()
	Global.day += 1
