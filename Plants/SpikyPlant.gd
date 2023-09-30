class_name SpikyPlant
extends BasePlant

static func plant_name():
	return "Spiky Plant"

static func plant_description():
	return "Kills everything around it."

func plant_type():
	return Global.PlantType.SPIKY_PLANT
