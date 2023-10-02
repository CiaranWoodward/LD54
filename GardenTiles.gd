class_name GardenTiles
extends TileMap

@export var radius: int = 3

@export var ripple_delay = 0.1
@export var ripple_height = 10.0
@export var ripple_height_decay = 2.0
@export var ripple_sweep_delay = 0.05
@export var ripple_sweep_height = 5.0

var _tile_map = {}
var _minx = 0

func _add_tile_to_set(x: int, y: int, tileScene: Resource):
	if x < _minx:
		_minx = x
	var newTile = tileScene.instantiate()
	var pos = Vector2i(x, y)
	newTile.position = self.map_to_local(pos)
	add_child(newTile)
	_tile_map[pos] = newTile

# Called when the node enters the scene tree for the first time.
func _ready():
	var tileScene = preload("res://Tiles/plant_tile.tscn")
	for y in range(-radius, radius+1):
		if (y < 0):
			for x in range (-radius-y-1, radius):
				_add_tile_to_set(x, y, tileScene)
		else:
			for x in range (-radius-1, radius-y):
				_add_tile_to_set(x, y, tileScene)
	
		
func get_plant_tile(coords : Vector2i):
	if !_tile_map.has(coords):
		return null
	return _tile_map[coords]

func get_plant_tile_at_pos(pos : Vector2):
	return get_plant_tile(local_to_map(pos))

func ripple_from(pos : Vector2i):
	var posf = Vector2(pos)
	_tile_map[pos].run_poof_effect()
	for coord in _tile_map.keys():
		var distance = posf.distance_to(Vector2(coord))
		var delay = distance * ripple_delay
		var height = ripple_height - distance * ripple_height_decay
		if height <= 0: continue
		_tile_map[coord].ripple(height, delay, false)

func ripple_sweep():
	for coord in _tile_map.keys():
		var distance = Vector2(coord).x - _minx
		var delay = distance * ripple_sweep_delay
		var height = ripple_sweep_height
		_tile_map[coord].ripple(height, delay, true)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func tick():
	for tile in _tile_map.values():
		tile.tick()
	ripple_sweep()
