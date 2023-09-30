extends Node

# enum for all plant types
enum PlantType {WEED, FLOWER, BERRY_VINE, SPIKY_PLANT, SUCCULENT, ORANGE_TREE, MUSHROOM}

# enum for all produce types
enum ProduceType {FLOWER, BERRY, ORANGE, SUCCULENT, MUSHROOM}

# inverntory for produce
var produceInventory: Dictionary = ProduceType.values().reduce(func(accum, type): accum[type] = 0, {})

# inventory for seeds
var seedInventory: Dictionary = PlantType.values().reduce(func(accum, type): accum[type] = 10, {})

var produceQuota: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
