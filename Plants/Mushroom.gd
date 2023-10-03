@tool
class_name Mushroom
extends BasePlant

@export var random_wave_min = 3.0
@export var random_wave_max = 8.0

static func plant_name():
	return "Mushroom"

static func plant_description():
	return "Thrives on dead plant life. Spreads to nearby dead plants."
	
func harvest_description() -> Dictionary:
	return {
		"name": plant_name(),
		"amount": str(cluster_count)
	}
	
var cluster_count = 0: set = set_cluster_count
var cluster_varient = randi_range(0, 1)

func set_cluster_count(newCount):
	cluster_count = newCount
	if (newCount >= 6):
		cluster_count = 6
	elif (newCount <= 0):
		cluster_count = 0
	else:
		cluster_count = newCount

func reset():
	cluster_count = 0
	for child in $Cluster.get_children():
		child.visible = false;
		child.get_node("IndiMush/Leggy").visible = cluster_varient == 0
		child.get_node("IndiMush/Stumpy").visible = cluster_varient == 1
		child.get_node("IndiMush/Leggy").frame = randi_range(0, 2)
		child.get_node("IndiMush/Stumpy").frame = randi_range(0, 2)

func _ready():
	super()
	reset()
	$Cluster.get_children().pick_random().visible = true
	cluster_count += 1
	_random_wave()

func plant_type():
	return Global.PlantType.MUSHROOM
	
func can_sow(tile : PlantTile, use_seed: bool = true) -> bool:
	if use_seed && Global.get_seed_count(plant_type()) <= 0:
		return false
	return !tile.has_adjacent(Global.PlantType.SPIKY_PLANT) && tile.is_occupied() && tile.child_plant.status == Status.DEAD && !is_instance_valid(tile.child_plant.hosted_plant)
	
func sow(tile: PlantTile, use_seed: bool = true):
	if !can_sow(tile, use_seed):
		return false
	if use_seed:
		Global.change_seed_count(plant_type(), -1)
	var host = tile.child_plant
	host.ticked.connect(tick)
	host.harvested.connect(harvest)
	host.destroyed.connect(destroy)
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
			mushroom.sow(tile, false)
			
func can_harvest() -> bool:
	return age > 0 && cluster_count > 0

func harvest():
	Global.change_produce_count(Global.ProduceType.MUSHROOM, cluster_count)
	destroyed.emit()
	parent_tile.child_plant.hosted_plant = null
	parent_tile.remove_child(hosted_plant)
	queue_free()

func _random_wave():
	while true:
		var tween = create_tween()
		tween.tween_interval(randf_range(random_wave_min, random_wave_max))
		await tween.finished
		$AnimationPlayer.play("Wave")
		await $AnimationPlayer.animation_finished
