extends Node2D

@export var AP_per_day = 5

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cursor.clear_action_func = $HUD.clear_action
	$Cursor.connect("interacted_with_tile", func(tile): $GardenTiles.ripple_from($GardenTiles.local_to_map(tile.position)))
	Global.action_points = AP_per_day
	Global.day = 0
	# This should trigger only the start dialogue.
	_tick_story()

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

func _tick_story():
	$HUD.set_show_action_panel(false)
	await Story.tick_story($HUD/Dialogue)
	$HUD.set_show_action_panel(true)

func _on_turn_end(): 
	$HUD.clear_action()
	$GardenTiles.tick()
	Global.day += 1
	Global.action_points = AP_per_day
	await _tick_story()
