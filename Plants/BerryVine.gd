class_name BerryVine
extends BasePlant

@export var time_to_grow: int = 4
@export var harvest_amount: int = 5

var bush_varient = randi_range(0, 1)
var berry_varient = randi_range(0, 2)

var _berry_tween

static func plant_name():
	return "Berry Vine"

static func plant_description():
	return "Spreads and fruits with delicious berries! Will die if land becomes infertile."

func harvest_description() -> Dictionary:
	return {
		"name": "Berry",
		"amount": str(harvest_amount)
	}

func plant_type():
	return Global.PlantType.BERRY_VINE
	
func _ready():
	super()
	$BerryVine/Centre/Berry.modulate = Color.TRANSPARENT
	
func kill():
	if (status != Status.DEAD):
		super()
		status = Status.DEAD
		$AnimationPlayer.queue("Dying")
		$AnimationPlayer.queue("Withered")
	
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && tile.is_fertile && super(tile, use_seed)
	
func tick():
	super()
	if (status != Status.DEAD):
		parent_tile.fertility -= 1
		if (!parent_tile.is_fertile): 
			kill()
		elif age > time_to_grow:
			spread()
			if (status != Status.HARVESTABLE):
				_berry_tween = create_tween()
				_berry_tween.tween_property($BerryVine/Centre/Berry, "modulate", Color.WHITE, 0.5)
				status = Status.HARVESTABLE
		elif age < time_to_grow:
			if (status != Status.GROWING):
				status = Status.GROWING

func harvest():
	super()
	if (status == Status.HARVESTABLE):
		status = Status.GROWING
		_berry_tween = create_tween()
		_berry_tween.tween_property($BerryVine/Centre/Berry, "modulate", Color.TRANSPARENT, 0.5)
		Global.change_produce_count(Global.ProduceType.BERRY, harvest_amount)
		age = 0
		
func spread_impl(tiles: Array):
	for tile in tiles:
		if (!tile.is_occupied() && tile.is_fertile):
			var berryVine = load("res://Plants/BerryVine.tscn").instantiate()
			berryVine.sow(tile, false)
			show_connector(berryVine)

func show_connector(new_vine : BerryVine, recurse = true):
	var diff = new_vine.parent_tile.coords - parent_tile.coords
	match diff:
		Vector2i(-1, 1):
			if scale.x > 0: $AnimationPlayer.queue("SpreadLeft")
			else: $AnimationPlayer.queue("SpreadRight")
		Vector2i(0, 1):
			$AnimationPlayer.queue("SpreadCentre")
		Vector2i(1, 0):
			if scale.x > 0: $AnimationPlayer.queue("SpreadRight")
			else: $AnimationPlayer.queue("SpreadLeft")
		_:
			if recurse:
				new_vine.show_connector(self, false)

func destroy():
	super()
