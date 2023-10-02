class_name Flower
extends BasePlant

## How long until the plant is fully grown
@export var time_to_grow: int = 2
@export var time_to_dead: int = 5

@export var colors : Array[Color] = [Color.WHITE, Color.PINK, Color.LIGHT_YELLOW]

@onready var stateMachine = $AnimationTree["parameters/playback"]

static func plant_name():
	return "Flower"

static func plant_description():
	return "Improves soil moisture for later planting."

func harvest_description() -> Dictionary:
	if (status == Status.DEAD):
		return {
			"name": "Flower Seed",
			"amount": "1-2"
		}
	return {
			"name": plant_name(),
			"amount": "1"
		}

func _ready():
	super()
	$Flower/Bud.modulate = colors[randi_range(0, colors.size()-1)]
	$PetalFall.modulate = $Flower/Bud.modulate

func plant_type():
	return Global.PlantType.FLOWER
	
func can_harvest() -> bool:
	return status == Status.DEAD || super()

func harvest():
	super()
	if status == Status.HARVESTABLE:
		Global.change_produce_count(Global.ProduceType.FLOWER, 1)
		destroy()
	if status == Status.DEAD:
		Global.change_seed_count(Global.PlantType.FLOWER, randi_range(1, 2))
		destroy()

func destroy():
	super()
	
func kill():
	super()
	age += time_to_dead
	status = Status.DEAD
	stateMachine.travel("Withered")
	$Idle.stop()

func tick():
	super()
	# if flower isnt dead, increase fertility of tile and tiles adjacent
	if status != Status.DEAD:
		parent_tile.fertility += 2
		var to_fertilize = parent_tile.getAdjacent()
		for tile in to_fertilize:
			tile.fertility += 1
	if age > time_to_dead:
		if status != Status.DEAD:
			kill()
	elif age > time_to_grow:
		if status != Status.HARVESTABLE:
			stateMachine.travel("Big")
			spread()
		status = Status.HARVESTABLE

func spread_impl(tiles):
	for tile in tiles:
		if (!tile.is_occupied()):
			var flower = load("res://Plants/Flower.tscn").instantiate()
			flower.sow(tile, false)
			

func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && super(tile, use_seed)

func sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return super(tile, use_seed)
