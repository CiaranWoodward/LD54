class_name Succulent
extends BasePlant

## How long until the plant is fully grown
@export var time_to_grow: int = 2
@export var time_to_dead: int = 5

@onready var stateMachine = $AnimationTree["parameters/playback"]

static func plant_name():
	return "Succulent"

static func plant_description():
	return "Will die if overwatered."
	
func harvest_description() -> Dictionary:
	return {
		"name": plant_name(),
		"amount": "1"
	}

func _ready():
	super()

func plant_type():
	return Global.PlantType.SUCCULENT
	
func harvest():
	super()
	if status == Status.HARVESTABLE:
		Global.change_produce_count(Global.ProduceType.SUCCULENT, 1)
		destroy()

func destroy():
	super()
	
func kill():
	super()
	age += time_to_dead
	status = Status.DEAD
	stateMachine.travel("Withered")

func tick():
	super()
	if status != Status.DEAD:
		if parent_tile.is_fertile:
			kill()
		elif age > time_to_dead:
			kill()
		elif age > time_to_grow:
			if status != Status.HARVESTABLE:
				spread()
				status = Status.HARVESTABLE
				stateMachine.travel("Big")

func spread_impl(tiles):
	for tile in tiles:
		if (!tile.is_occupied()):
			var succulent = load("res://Plants/Succulent.tscn").instantiate()
			succulent.sow(tile, false)

func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && !tile.is_fertile && super(tile, use_seed)

func sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return super(tile, use_seed)


