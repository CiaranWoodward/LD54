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
	print(get_plant_name(PlantType.WEED))
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_plant_name(type : PlantType):
	return get_plant_class(type).plant_name()

func get_plant_description(type : PlantType):
	return get_plant_class(type).plant_description()

func get_plant_scene(type : PlantType) -> PackedScene:
	match(type):
		PlantType.WEED: return load("res://Plants/Weed.tscn")
		PlantType.FLOWER: return load("res://Plants/Flower.tscn")
		PlantType.BERRY_VINE: return load("res://Plants/BerryVine.tscn")
		PlantType.SPIKY_PLANT: return load("res://Plants/SpikyPlant.tscn")
		PlantType.SUCCULENT: return load("res://Plants/Succulent.tscn")
		PlantType.ORANGE_TREE: return load("res://Plants/OrangeTree.tscn")
		PlantType.MUSHROOM: return load("res://Plants/Mushroom.tscn")
	return null

func get_plant_class(type : PlantType):
	match(type):
		PlantType.WEED: return Weed
		PlantType.FLOWER: return Flower
		PlantType.BERRY_VINE: return BerryVine
		PlantType.SPIKY_PLANT: return SpikyPlant
		PlantType.SUCCULENT: return Succulent
		PlantType.ORANGE_TREE: return OrangeTree
		PlantType.MUSHROOM: return Mushroom
	return null
