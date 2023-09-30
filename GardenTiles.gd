extends TileMap

@export var dimensions = Vector2i(10,10)

var _tile_map = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var tileScene = preload("res://Tiles/plant_tile.tscn")
	for x in range (dimensions.x):
		for y in range (dimensions.y):
			var newTile = tileScene.instantiate()
			var pos = Vector2i(x, y)
			newTile.position = self.map_to_local(pos)
			add_child(newTile)
			_tile_map[pos] = newTile
			
func get_plant_tile(coords : Vector2i):
	return _tile_map[coords]

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
