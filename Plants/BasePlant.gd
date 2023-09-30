class_name BasePlant
extends Node2D

enum Status { DEAD, GROWING, HARVESTABLE }

var status : Status = Status.GROWING
var age : int = 0
var parent_tile : PlantTile = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

## Harvest the fruit (Might also destroy for some plants)
func harvest():
	pass

## Destroy the plant (Also harvests anything harvestable)
func destroy():
	pass

## Run the plant logic, which might affect neighboring tiles
func tick():
	age += 1

## Can this plant be sown on this tile
func can_sow(tile : PlantTile) -> bool:
	if (tile.is_occupied()):
			return false
	return true

## Attempt to sow a seed on a tile, returns false if unsuccessful
func sow(tile : PlantTile) -> bool:
	if !can_sow(tile):
		return false
	tile.child_plant = self
	parent_tile = tile
	return true
