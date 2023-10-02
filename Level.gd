extends Node2D

@export var AP_per_day = 5

var _sky_tween

# Called when the node enters the scene tree for the first time.
func _ready():
	$Cursor.clear_action_func = $HUD.clear_action
	$Cursor.connect("interacted_with_tile", func(tile): $GardenTiles.ripple_from($GardenTiles.local_to_map(tile.position)))
	$DayCycle.assigned_animation = "DayCycle"
	_update_sky_from_ap(AP_per_day)
	Global.action_points_changed.connect(_update_sky_from_ap)
	Global.action_points = AP_per_day
	Global.day = 0
	Global.change_produce_count(Global.ProduceType.MUSHROOM, 1)
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

func _reset_day():
	await _update_sky(1.0)
	$DayCycle.seek(0)

func _update_sky_from_ap(ap):
	var t = Tween.interpolate_value(0.2, 0.8, float(AP_per_day-ap)/float(AP_per_day), 1.0, Tween.TRANS_LINEAR, Tween.EASE_IN)
	await _update_sky(t)

func _update_sky(time : float):
	if is_instance_valid(_sky_tween):
		await _sky_tween.finished
	_sky_tween = create_tween()
	var diff = time - $DayCycle.current_animation_position
	_sky_tween.tween_interval(abs(diff) / $DayCycle.speed_scale)
	if diff > 0: $DayCycle.play("DayCycle", -1, 1.0)
	elif diff < 0: $DayCycle.play("DayCycle", -1, -1.0)
	await _sky_tween.finished
	_sky_tween = null
	$DayCycle.pause()

func _on_turn_end(): 
	$HUD.clear_action()
	$GardenTiles.tick()
	Global.action_points = 0
	await _tick_story()
	await _reset_day()
	Global.day += 1
	Global.action_points = AP_per_day
	await _update_sky_from_ap(AP_per_day)
