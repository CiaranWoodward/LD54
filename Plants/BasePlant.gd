class_name BasePlant
extends Node2D

signal ticked
signal harvested
signal destroyed

enum Status { DEAD, GROWING, HARVESTABLE }

var status : Status = Status.GROWING
var age : int = 0
var parent_tile : PlantTile = null
var hosted_plant: BasePlant = null

## Percentage chance of spreading to adjacent tiles
@export var spread_percent_fertile = 0
@export var spread_percent_infertile = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	scale.x *= 1 if randi_range(0, 1) else -1
	scale *= randf_range(0.9, 1.1)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Can the fruit be harvested?
func can_harvest() -> bool:
	return false

## Harvest the fruit (Might also destroy for some plants)
func harvest():
	harvested.emit()

## Destroy the plant (Also harvests anything harvestable)
func destroy():
	if is_instance_valid(parent_tile):
		destroyed.emit()
		parent_tile.child_plant = null
		parent_tile = null

## Make the plant dead
func kill():
	pass

## Run the plant logic, which might affect neighboring tiles
func tick():
	age += 1
	ticked.emit()

## Can this plant be sown on this tile
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	if (tile.is_occupied()):
		return false
	if use_seed && Global.get_seed_count(plant_type()) <= 0:
		return false
	return true

## Attempt to sow a seed on a tile, returns false if unsuccessful
func sow(tile : PlantTile, use_seed: bool = true) -> bool:
	if !can_sow(tile, use_seed):
		return false
	if use_seed:
		Global.change_seed_count(plant_type(), -1)
	tile.child_plant = self
	parent_tile = tile
	return true

func plant_type() -> Global.PlantType:
	assert(false)
	return Global.PlantType.WEED

# function to get the tiles to attempt to spread to
func get_spread_tiles() -> Array:
	return parent_tile.getAdjacent().filter(func(tile: PlantTile):
		if tile.is_fertile:
			return randi_range(0, 100) < spread_percent_fertile
		else:
			return randi_range(0, 100) < spread_percent_infertile
	)

## Override this with the spreading logic for the plant
func spread_impl(tiles: Array):
	assert(false, "ERROR: Spreding logic not implemented!")

# function to spread the plant to the candidate tiles
func spread():
	spread_impl(get_spread_tiles())
	
