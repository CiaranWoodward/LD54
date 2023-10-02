class_name OrangeTree
extends BasePlant

## How long until the plant is fully grown
@export var time_to_grow: int = 4
@export var time_to_fruit: int = 2
@export var harvest_amount: int = 10

@onready var stateMachine: AnimationNodeStateMachinePlayback = $AnimationTree["parameters/playback"]

var _orange_tween

static func plant_name():
	return "Orange Tree"

static func plant_description():
	return "Draws in moisture from a wide area. Dies if infertile."
	
func harvest_description() -> Dictionary:
	return {
		"name": "Orange",
		"amount": str(harvest_amount)
	}

func plant_type():
	return Global.PlantType.ORANGE_TREE

func _ready():
	super()
	$Tree/Leaves/Orange.visible = true
	$Tree/Leaves/Orange.modulate = Color.TRANSPARENT
	
func harvest():
	super()
	if status == Status.HARVESTABLE:
		Global.change_produce_count(Global.ProduceType.ORANGE, harvest_amount)
		age = time_to_grow
		_orange_tween = create_tween()
		_orange_tween.tween_property($Tree/Leaves/Orange, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)
		status == Status.GROWING

func destroy():
	super()
	
func kill():
	super()
	status = Status.DEAD
	stateMachine.travel("Withered")
	age = time_to_grow
	_orange_tween = create_tween()
	_orange_tween.tween_property($Tree/Leaves/Orange, "modulate", Color.TRANSPARENT, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

func tick():
	super()
	if status != Status.DEAD:
		if !parent_tile.is_fertile:
			kill()
		
		# absorb moisture from tiles around tree
		var adjacent_fertile_tiles = parent_tile.getAdjacent().filter(func(tile: PlantTile):
			return tile.is_fertile
		)
		for tile in adjacent_fertile_tiles:
			tile.fertility -= 1
		
		parent_tile.fertility += (adjacent_fertile_tiles.size() - 2)
		
		if (age > time_to_grow && stateMachine.get_current_node() != "Big"):
			stateMachine.travel("Big")
		
		if (age - time_to_grow > time_to_fruit):
			status = Status.HARVESTABLE
			_orange_tween = create_tween()
			_orange_tween.tween_property($Tree/Leaves/Orange, "modulate", Color.WHITE, 0.5).set_ease(Tween.EASE_IN).set_trans(Tween.TRANS_SINE)

func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return tile.is_fertile && super(tile, use_seed)

func sow(tile : PlantTile, use_seed: bool = true) -> bool:
	return super(tile, use_seed)
