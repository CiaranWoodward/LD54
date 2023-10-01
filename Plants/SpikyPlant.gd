class_name SpikyPlant
extends BasePlant

@export var kill_percent: int = 90

static func plant_name():
	return "Spiky Plant"

static func plant_description():
	return "Kills plants around it."

func plant_type():
	return Global.PlantType.SPIKY_PLANT
	
func tick():
	super()
	# get the tiles that the spiky plant will kill
	var toKill = parent_tile.getAdjacent().filter(func(tile: PlantTile):
		return randi_range(0, 100) < kill_percent
	).filter(func(tile: PlantTile):
		return tile.is_occupied()
	).filter(func(tile: PlantTile):
		return tile.child_plant.plant_type() != Global.PlantType.SPIKY_PLANT
	).filter(func(tile: PlantTile):
		return tile.child_plant.status != Status.DEAD
	)
	# Kill the plant if the plant is not a spiky plant and is not dead
	for tile in toKill:
		tile.child_plant.kill()
		
func kill():
	super()
	destroy()

func can_sow(tile : PlantTile) -> bool:
	return super(tile)
