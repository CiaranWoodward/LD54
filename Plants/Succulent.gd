class_name Succulent
extends BasePlant

static func plant_name():
	return "Succulent"

static func plant_description():
	return "Will die if overwatered."

func plant_type():
	return Global.PlantType.SUCCULENT
	
func kill():
	super()
	destroy()
	
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && super(tile, use_seed)

