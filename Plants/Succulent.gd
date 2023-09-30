class_name Succulent
extends BasePlant

static func plant_name():
	return "Succulent"

static func plant_description():
	return "Will die if overwatered."

func plant_type():
	return Global.PlantType.SUCCULENT
