class_name GardenTiles
extends TileMap

@export var radius: int = 3

@export var ripple_delay = 0.1
@export var ripple_height = 10.0
@export var ripple_height_decay = 2.0
var _ripple_tweens = []

var _tile_map = {}

func _add_tile_to_set(x: int, y: int, tileScene: Resource):
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
	_ripple_tweens.clear()
	for coord in _tile_map.keys():
		var distance = posf.distance_to(Vector2(coord))
		var delay = distance * ripple_delay
		var height = ripple_height - distance * ripple_height_decay
		if height <= 0: continue
		_tile_map[coord].ripple(height, delay)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func tick():
	for tile in _tile_map.values():
		tile.tick()
