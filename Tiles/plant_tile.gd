class_name PlantTile
extends Node2D

const MAX_FERTILITY = 10

@export var decay_percent = 20

@export var color_fertile = Color.BROWN
@export var color_dry = Color.BEIGE
@export var color_random = 0.05
@export var ripple_period = 0.25
@export_range(0.00, 1.0) var ripple_inverse_damping = 0.5

var fertility : int = randi_range(4, 7) : set = set_fertile
var is_fertile: bool = fertility > 5
var child_plant : BasePlant = null : set = set_child_plant
var coords : Vector2i = Vector2i.ZERO

var _dry_tween
var _color_tween
var _base_position
var _next_height = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_image()
	_update_color()
	_base_position = position

func set_fertile(newFertile):
	var was_fertile = is_fertile
	fertility = newFertile
	if fertility > MAX_FERTILITY:
		fertility = MAX_FERTILITY
	if fertility < 0:
		fertility = 0
	if (was_fertile && fertility <= 3):
		is_fertile = false
	if (!was_fertile && fertility >= 7):
		is_fertile = true
	if is_fertile != was_fertile:
		_update_image()
	_update_color()

func _update_image():
	if is_fertile:
		$Tile/Dry.visible = false
		$Tile/Wet.frame = randi() % $Tile/Wet.sprite_frames.get_frame_count("default")
		$Tile/Wet.scale = Vector2(1 if randi() % 2 else -1, 1)
		if $Tile/Dry.visible:
			_dry_tween = create_tween()
			_dry_tween.tween_property($Tile/Dry, "modulate", Color.TRANSPARENT, randf_range(0.8, 1.5)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)
			_dry_tween.tween_callback(func(): $Tile/Dry.visible = false)
	else:
		$Tile/Dry.modulate = Color.TRANSPARENT
		$Tile/Dry.visible = true
		$Tile/Dry.frame = randi() % $Tile/Dry.sprite_frames.get_frame_count("default")
		$Tile/Dry.scale = Vector2(1 if randi() % 2 else -1, 1)
		_dry_tween = create_tween()
		_dry_tween.tween_property($Tile/Dry, "modulate", Color.WHITE, randf_range(0.8, 1.5)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func _update_color():
	var frac = fertility / float(MAX_FERTILITY)
	frac += randf_range(-color_random, color_random)
	var newcolor = Tween.interpolate_value(color_dry, color_fertile - color_dry, frac, 1, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	_color_tween = create_tween()
	_color_tween.tween_property($Tile, "modulate", newcolor, randf_range(0.8, 1.5)).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_SINE)

func run_poof_effect():
	$Tile/SowPoof.emitting = true

func ripple(height: float, delay: float, forced: bool):
	if !forced && height < _next_height:
		return
	if height < 0.5:
		position = _base_position
		_next_height = 0.0
		return
	var offset = Vector2(0, height)
	var new_tween = create_tween()
	new_tween.tween_property(self, "position", _base_position, delay).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	new_tween.tween_property(self, "position", _base_position + offset, ripple_period / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	new_tween.tween_property(self, "position", _base_position - offset / 2, ripple_period).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	new_tween.tween_property(self, "position", _base_position, ripple_period / 2).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	if !forced:
		_next_height = height * ripple_inverse_damping
		new_tween.tween_callback(func(): ripple(_next_height, 0.0, false))

func set_child_plant(newChildPlant: BasePlant): 
	if is_instance_valid(child_plant):
		self.remove_child(child_plant)
	if is_instance_valid(newChildPlant):
		self.add_child(newChildPlant)
	child_plant = newChildPlant

func getAdjacent() -> Array:
	var parent = (self.get_parent() as GardenTiles)
	return parent.get_surrounding_cells(parent.local_to_map(position)).map(func(pos: Vector2i):
		return parent.get_plant_tile(pos)
	).filter(func(tile: PlantTile): 
		return is_instance_valid(tile)
	).map(func(tile):
		return tile as PlantTile
	)

func has_adjacent(type = null) -> bool:
	return !getAdjacent().filter(func(tile: PlantTile): 
		return tile.is_occupied()
	).filter(func(tile: PlantTile): 
		return type == null || tile.child_plant.plant_type() == type
	).is_empty()

func is_occupied() -> bool:
	return is_instance_valid(child_plant)
	
func tick():
	# decay the fertility by 1 randomly if unoccupied
	if is_occupied():
		child_plant.tick()
	if randi_range(0, 100) < decay_percent:
		self.fertility -= 1
		
	# if edge tile have a chance to sow a weed
	if (randi_range(0, 100) < Global.weed_percent && getAdjacent().size() < 6):
		var weed = load("res://Plants/Weed.tscn").instantiate()
		weed.sow(self, false)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

