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
	return "Improves soil mositure for later planting."

func _ready():
	scale.x = 1 if randi_range(0, 1) else -1
	scale *= randf_range(0.9, 1.1)
	$Flower/Bud.modulate = colors[randi_range(0, colors.size()-1)]
	$PetalFall.modulate = $Flower/Bud.modulate

func plant_type():
	return Global.PlantType.FLOWER

func harvest():
	if status == Status.HARVESTABLE:
		Global.change_produce_count(Global.ProduceType.FLOWER, 1)
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
	# if flower isnt dead, increase fertility of tile and tiles adjacent
	if status != Status.DEAD:
		parent_tile.fertility += 2
		var to_fertilize = parent_tile.getAdjacent()
		for tile in to_fertilize:
			tile.fertility += 1
	if age > time_to_dead:
		if status != Status.DEAD:
			stateMachine.travel("Withered")
		status = Status.DEAD
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
