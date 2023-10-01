@tool
class_name Mushroom
extends BasePlant

static func plant_name():
	return "Mushroom"

static func plant_description():
	return "Thrives on dead plant life."
	
var cluster_count = 1: set = set_cluster_count
var cluster_varient = randi_range(0, 1)

func set_cluster_count(newCount):
	cluster_count = newCount
	if (newCount >= 6):
		cluster_count = 6
	elif (newCount <= 0):
		cluster_count = 0
	else:
		cluster_count = newCount
	
var host: BasePlant;

func _ready():
	scale.x = 1 if randi_range(0, 1) else -1
	scale *= randf_range(0.9, 1.1)
	for child in $Cluster.get_children():
		child.visible = false;
		child.get_node("IndiMush/Leggy").visible = cluster_varient == 0
		child.get_node("IndiMush/Stumpy").visible = cluster_varient == 1
	$Cluster.get_children().pick_random().visible = true

func plant_type():
	return Global.PlantType.MUSHROOM
	
func can_sow(tile : PlantTile) -> bool:
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && tile.is_occupied() && tile.child_plant.status == Status.DEAD && Global.get_seed_count(plant_type()) > 0
	
func sow(tile: PlantTile):
	if !can_sow(tile):
		return false
	Global.change_seed_count(plant_type(), -1)
	host = tile.child_plant
	host.ticked.connect(tick)
	parent_tile = tile
	host.add_child(self)
	host.hosted_plant = self
	return true
	
func tick():
	super()
	cluster_count += 1
	var next_indi_mush = $Cluster.get_children().filter(func(child):
		return !child.visible
	).pick_random()
	if (is_instance_valid(next_indi_mush)):
		next_indi_mush.visible = true
	
	if cluster_count >= 6:
		spread()
	
func spread_impl(tiles):
	for tile in tiles:
		if (tile.is_occupied() && tile.child_plant.status == Status.DEAD && tile.child_plant.hosted_plant == null):
			var mushroom = load("res://Plants/Mushroom.tscn").instantiate()
			mushroom.cluster_varient = cluster_varient
			mushroom.sow(tile)
