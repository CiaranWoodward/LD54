class_name PlantTile
extends Node2D

const MAX_FERTILITY = 10

var fertility : int = 2 : set = set_fertile
var child_plant = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func get_child_plant():
	return null

func set_fertile(newFertile):
	if fertility > MAX_FERTILITY:
		fertility = MAX_FERTILITY
	if fertility < 0:
		fertility = 0

func is_fertile() -> bool:
	return (fertility > 5)

func is_occupied() -> bool:
	return is_instance_valid(child_plant)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
