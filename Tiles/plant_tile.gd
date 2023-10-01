class_name PlantTile
extends Node2D

const MAX_FERTILITY = 10

@export var decay_percent = 50

@export var color_fertile = Color.BROWN
@export var color_dry = Color.BEIGE
@export var color_random = 0.05

var fertility : int = 10 : set = set_fertile
var child_plant : BasePlant = null : set = set_child_plant

var _dry_tween
var _color_tween

# Called when the node enters the scene tree for the first time.
func _ready():
	_update_image()
	_update_color()

func set_fertile(newFertile):
	var was_fertile = is_fertile()
	fertility = newFertile
	if fertility > MAX_FERTILITY:
		fertility = MAX_FERTILITY
	if fertility < 0:
		fertility = 0
	if is_fertile() != was_fertile:
		_update_image()
	_update_color()

func _update_image():
	if is_fertile():
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

func set_child_plant(newChildPlant: BasePlant): 
	if is_instance_valid(child_plant):
		self.remove_child(child_plant)
	self.add_child(newChildPlant)
	child_plant = newChildPlant

func getAdjacent() -> Array[PlantTile]:
	var parent = (self.get_parent() as GardenTiles)
	return parent.get_surrounding_cells(self.position).map(func(pos: Vector2i):
		return parent.get_plant_tile(pos))

func is_fertile() -> bool:
	return (fertility > 5)

func is_occupied() -> bool:
	return is_instance_valid(child_plant)
	
func tick():
	# decay the fertility by 1 randomly if unoccupied
	if is_occupied():
		child_plant.tick()
	elif randi() % 100 < decay_percent:
		self.fertility -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

