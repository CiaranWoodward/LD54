class_name BerryVine
extends BasePlant

@export var time_to_grow: int = 4

var bush_varient = randi_range(0, 1)
var berry_varient = randi_range(0, 2)

static func plant_name():
	return "Berry Vine"

static func plant_description():
	return "Spreads and fruits with delicious berries! Will die if land becomes infertile."

func _ready():
	$AnimationTree.active = true

func plant_type():
	return Global.PlantType.BERRY_VINE
	
func _ready():
	scale.x = 1 if randi_range(0, 1) else -1
	scale *= randf_range(0.9, 1.1)
	
func kill():
	if (status != Status.DEAD):
		super()
		status = Status.DEAD
	
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && tile.is_fertile && super(tile, use_seed)
	
func tick():
	super()
	if (status != Status.DEAD):
		if (!parent_tile.is_fertile): 
			kill()
		elif age > time_to_grow:
			spread()
			if (status != Status.HARVESTABLE):
				status = Status.HARVESTABLE
		elif age < time_to_grow:
			if (status != Status.GROWING):
				status = Status.GROWING

func harvest():
	super()
	if (status == Status.HARVESTABLE):
		Global.change_produce_count(Global.ProduceType.BERRY, 5)
		age = 0
		
func spread_impl(tiles: Array):
	for tile in tiles:
		if (!tile.is_occupied() && tile.is_fertile):
			var berryVine = load("res://Plants/BerryVine.tscn").instantiate()
			berryVine.sow(tile, false)
	
func destroy():
	super()
	
		
