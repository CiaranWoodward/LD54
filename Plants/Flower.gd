class_name Flower
extends BasePlant

## How long until the plant is fully grown
@export var time_to_grow = 3
@export var time_to_dead = 6

static func plant_name():
	return "Flower"

static func plant_description():
	return "Improves soil mositure for later planting."
	
func plant_type():
	return Global.PlantType.FLOWER

func harvest():
	Global.change_produce_count(Global.ProduceType.FLOWER, 1)
	destroy()

func destroy():
	super.destroy()

func tick():
	super()
	if status != Status.DEAD:
		parent_tile.fertility += 2
	if age > time_to_dead:
		status = Status.DEAD
	elif age > time_to_grow:
		status = Status.HARVESTABLE

func can_sow(tile : PlantTile) -> bool:
	return super(tile)

func sow(tile : PlantTile) -> bool:
	return super(tile)
