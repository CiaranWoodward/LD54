class_name BerryVine
extends BasePlant

static func plant_name():
	return "Berry Vine"

static func plant_description():
	return "Spreads and fruits with delicious berries!"

func plant_type():
	return Global.PlantType.BERRY_VINE
	
func kill():
	super()
	destroy()
	
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && super(tile, use_seed)
