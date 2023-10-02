class_name Weed
extends BasePlant

static func plant_name():
	return "Weed"

static func plant_description():
	return "Why won't it die?!"
	
func _ready():
	super()
	$Weed/AnimatedSprite2D.frame = randi_range(0, 1)

func plant_type():
	return Global.PlantType.WEED

func harvest():
	destroy()

func destroy():
	super()

func kill():
	super()
	destroy()

func tick():
	super()
	spread()
	
func spread_impl(tiles):
	var toSpread = tiles.filter(func(tile: PlantTile):
		return !(tile.is_occupied() && tile.child_plant.plant_type() == Global.PlantType.WEED)
	)
	# Create a new weed on the tiles which it is spreading to
	for tile in toSpread:
		if (tile.is_occupied() && tile.child_plant.status != Status.DEAD):
			tile.child_plant.kill()
		else:
			var weed = load("res://Plants/Weed.tscn").instantiate()
			weed.sow(tile, false)

func can_sow(tile : PlantTile, use_seed: bool = false) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT)

func sow(tile : PlantTile, use_seed: bool = false) -> bool:
	return super(tile, use_seed)
