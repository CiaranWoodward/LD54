extends BasePlant

## Percentage chance of weed spreading to adjacent tiles
@export var spread_percent_fertile = 20
@export var spread_percent_infertile = 10

func harvest():
	destroy()

func destroy():
	super.destroy()

func tick():
	super()
	# get the tiles this weed will spread to
	var spreading_to = parent_tile.getAdjacent().filter(func(tile: PlantTile): 
		if tile.is_fertile():
			return randi() % 100 < spread_percent_fertile
		else:
			return randi() % 100 < spread_percent_infertile
	)
	
	spreading_to.all(func(tile: PlantTile):
		var weed = load("res://Plants/Weed.tscn").instantiate()
		weed.sow(tile)
		return true
	)
	

func can_sow(tile : PlantTile) -> bool:
	return super(tile)

func sow(tile : PlantTile) -> bool:
	return super(tile)
