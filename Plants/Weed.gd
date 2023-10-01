class_name Weed
extends BasePlant

## Percentage chance of weed spreading to adjacent tiles
@export var spread_percent_fertile = 7
@export var spread_percent_infertile = 3

static func plant_name():
	return "Weed"

static func plant_description():
	return "Why won't it die?!"

func plant_type():
	return Global.PlantType.WEED

func harvest():
	destroy()

func destroy():
	super.destroy()

func tick():
	super()
	# get the tiles that the weed will spread to
	var toSpread = parent_tile.getAdjacent().filter(func(tile: PlantTile):
		# exclude occupied tiles
		if tile.is_occupied():
			return false
			
		if tile.is_fertile():
			return randi() % 100 < spread_percent_fertile
		else:
			return randi() % 100 < spread_percent_infertile
	)
	# Create a new weed on the tiles which it is spreading to
	for tile in toSpread:
		var weed = load("res://Plants/Weed.tscn").instantiate()
		weed.sow(tile)
	

func can_sow(tile : PlantTile) -> bool:
	return true

func sow(tile : PlantTile) -> bool:
	return super(tile)
