class_name GardenTiles
extends TileMap

@export var radius: int = 3

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

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func tick():
	for tile in _tile_map.values():
		tile.tick()
