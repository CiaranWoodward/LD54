class_name PlantTile
extends Node2D

const MAX_FERTILITY = 10

@export var decay_percent = 50

var fertility : int = 2 : set = set_fertile
var child_plant : BasePlant = null : set = set_child_plant

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_fertile(newFertile):
	if fertility > MAX_FERTILITY:
		fertility = MAX_FERTILITY
	if fertility < 0:
		fertility = 0
		
func set_child_plant(newChildPlant: BasePlant): 
	self.remove_child(child_plant)
	self.add_child(newChildPlant)
	child_plant = newChildPlant
		
func getAdjacent() -> Array[PlantTile]:
	var parent = (self.get_parent() as GardenTiles)
	return parent.get_surrounding_cells(self.position).map(func(pos: Vector2i):
		return parent.get_plant_tile(pos))

func is_fertile() -> bool:
	return (fertility > 5)

func is_occupied() -> bool:
	return is_instance_valid(child_plant)
	
func tick():
	# decay the fertility by 1 randomly if unoccupied
	if is_occupied():
		child_plant.tick()
	elif randi() % 100 < decay_percent:
		self.fertility -= 1

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	

