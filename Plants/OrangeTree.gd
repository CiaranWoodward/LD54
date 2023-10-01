class_name OrangeTree
extends BasePlant

static func plant_name():
	return "Orange Tree"

static func plant_description():
	return "Draws in moisture from a wide area."

func plant_type():
	return Global.PlantType.ORANGE_TREE
	
func kill():
	super()
	destroy()
	
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return super(tile, use_seed)
