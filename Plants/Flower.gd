extends BasePlant

## How long until the plant is fully grown
@export var time_to_grow = 3
@export var time_to_dead = 6

func harvest():
	Global.produceInventory.FLOWER += 1
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
