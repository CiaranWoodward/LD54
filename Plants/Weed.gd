class_name Weed
extends BasePlant

## Percentage chance of weed spreading to adjacent tiles
@export var spread_percent_fertile = 20
@export var spread_percent_infertile = 10

static func plant_name():
	return "Weed"

static func plant_description():
	return "Why won't it die?!"

func harvest():
	destroy()

func destroy():
	super.destroy()

func tick():
	super()
	# get the tiles that the weed will spread to
	parent_tile.getAdjacent().filter(func(tile: PlantTile):
		# exclude occupied tiles
		if tile.is_occupied():
			return false
			
		if tile.is_fertile():
			return randi() % 100 < spread_percent_fertile
		else:
			return randi() % 100 < spread_percent_infertile
	# Create a new weed on the tiles which it is spreading to
	).all(func(tile: PlantTile):
		var weed = load("res://Plants/Weed.tscn").instantiate()
		weed.sow(tile)
		return true
	)
	

func can_sow(tile : PlantTile) -> bool:
	return super(tile)

func sow(tile : PlantTile) -> bool:
	return super(tile)
