@tool
class_name Mushroom
extends BasePlant

static func plant_name():
	return "Mushroom"

static func plant_description():
	return "Thrives on dead plant life."

func plant_type():
	return Global.PlantType.MUSHROOM
