extends Node

signal inventory_updated
signal action_points_changed(points: int)
signal day_changed(day: int)

# enum for all plant types
enum PlantType {WEED, FLOWER, BERRY_VINE, SPIKY_PLANT, SUCCULENT, ORANGE_TREE, MUSHROOM}

# enum for all produce types
enum ProduceType {FLOWER, BERRY, ORANGE, SUCCULENT, MUSHROOM}

enum ActionType {NONE, HARVEST, DESTROY, PLANT, END_TURN}

# inventory for produce
var _produceInventory: Dictionary = ProduceType.values().reduce(func(accum, type):
	accum[type] = 0
	return accum, {})

# inventory for seeds
var _seedInventory: Dictionary = PlantType.values().reduce(func(accum, type):
	accum[type] = 10
	return accum, {})

var _produceQuota: Dictionary = {}

var action_points: int = 0: set = set_action_points

func set_action_points(new_action_points):
	action_points = new_action_points
	if (action_points < 0):
		action_points = 0
	action_points_changed.emit(action_points)
	
var day: int: set = set_day

func set_day(new_day):
	day = new_day
	day_changed.emit(day)
	

# Called when the node enters the scene tree for the first time.
func _ready():
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

func get_produce_name(type : ProduceType):
	match(type):
		ProduceType.FLOWER: return "Flower"
		ProduceType.BERRY: return "Berry"
		ProduceType.ORANGE: return "Orange"
		ProduceType.SUCCULENT: return "Succulent"
		ProduceType.MUSHROOM: return "Mushroom"
	return null

func is_quota_met():
	return _produceQuota.keys().all(
		func(key):
			return _produceInventory.get(key, 0) >= _produceQuota[key]
	)

## Take as much as possible towards the quota, leaving the remainder
func take_quota():
	for key in _produceQuota.keys():
		var q = _produceQuota[key]
		var diff =  _produceInventory[key] - q
		var leftover = -min(0, diff)
		_produceInventory[key] = max(0, diff)
		_produceQuota[key] = leftover
	inventory_updated.emit()

## Clear the quota to all zero
func clear_quota():
	for key in _produceQuota.keys():
		_produceQuota[key] = 0
	inventory_updated.emit()

func get_produce_count(type : ProduceType):
	return _produceInventory[type]
func get_seed_count(type : PlantType):
	return _seedInventory[type]
func get_quota_count(type : ProduceType):
	return _produceQuota.get(type, 0)
func set_produce_count(type : ProduceType, count : int):
	_produceInventory[type] = count
	inventory_updated.emit()
func set_seed_count(type : PlantType, count : int):
	_seedInventory[type] = count
	inventory_updated.emit()
func set_quota_count(type : ProduceType, count : int):
	_produceQuota[type] = count
	inventory_updated.emit()
func change_produce_count(type : ProduceType, delta : int):
	_produceInventory[type] += delta
	inventory_updated.emit()
func change_seed_count(type : PlantType, delta : int):
	_seedInventory[type] += delta
	inventory_updated.emit()
func change_quota_count(type : ProduceType, delta : int):
	_produceQuota[type] += delta
	inventory_updated.emit()
