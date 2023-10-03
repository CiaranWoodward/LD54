class_name SpikyPlant
extends BasePlant

@export var kill_percent: int = 90
@export var kill_turns: int = 5

@onready var stateMachine = $AnimationTree["parameters/playback"]

var _spike_tween

static func plant_name():
	return "Spike Shooter"

static func plant_description():
	return "Kills plants around it for several days. Very hardy."
	
func harvest_description() -> Dictionary:
	return {
		"name": "Spike Ball",
		"amount": "1"
	}
	
func _ready():
	super()
	$BaldPlant/Spikes.modulate = Color.WHITE

func plant_type():
	return Global.PlantType.SPIKY_PLANT
	
func tick():
	super()
	if (age < kill_turns):
		stateMachine.travel("Shoot")
		# get the tiles that the spiky plant will kill
		var toKill = parent_tile.getAdjacent().filter(func(tile: PlantTile):
			return randi_range(0, 100) < kill_percent
		).filter(func(tile: PlantTile):
			return tile.is_occupied()
		).filter(func(tile: PlantTile):
			return tile.child_plant.plant_type() != Global.PlantType.SPIKY_PLANT
		).filter(func(tile: PlantTile):
			return tile.child_plant.status != Status.DEAD
		)
		# Kill the plant if the plant is not a spiky plant and is not dead
		for tile in toKill:
			tile.child_plant.kill()
			
	elif(status != Status.HARVESTABLE):
		status = Status.HARVESTABLE
		_spike_tween = create_tween()
		_spike_tween.tween_property($BaldPlant/Spikes, "modulate", Color.TRANSPARENT, 1)
		
func kill():
	super()
	destroy()
	
func harvest():
	if status == Status.HARVESTABLE:
		Global.change_produce_count(Global.ProduceType.SPIKE_BALL, 1)
		destroy()

func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return super(tile, use_seed)
