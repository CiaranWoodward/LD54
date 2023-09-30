extends Node2D

@export var idle_color : Color = Color.WHITE
@export var invalid_color : Color = Color.WHITE
@export var valid_color : Color = Color.WHITE

var _current_action
var _current_plant
var _current_plantinstance
var _current_tile

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_current_tile(currentTile : PlantTile):
	if !is_instance_valid(currentTile):
		self.visible = false
		return
	self.visible = true
	self.global_position = currentTile.global_position
	_current_tile = currentTile
	if _current_action == Global.ActionType.PLANT:
		if _current_plantinstance.can_sow(currentTile):
			modulate = valid_color
		else:
			modulate = invalid_color
	else:
		modulate = idle_color

func change_action(newAction : Global.ActionType, plantType : Global.PlantType):
	_current_action = newAction
	_current_plant = plantType
	update_action()

func update_action():
	for child in get_children():
		child.visible = false
	match (_current_action):
		Global.ActionType.DESTROY:
			$Destroy.visible = true
		Global.ActionType.HARVEST:
			$Harvest.visible = true
		Global.ActionType.PLANT:
			_current_plantinstance = Global.get_plant_scene(_current_plant).instantiate()
			match(_current_plant):
				Global.PlantType.WEED:
					$Weed.visible = true
				Global.PlantType.FLOWER:
					$Flower.visible = true
				Global.PlantType.BERRY_VINE:
					$BerryVine.visible = true
				Global.PlantType.SPIKY_PLANT:
					$SpikyPlant.visible = true
				Global.PlantType.SUCCULENT:
					$Succulent.visible = true
				Global.PlantType.ORANGE_TREE:
					$OrangeTree.visible = true
				Global.PlantType.MUSHROOM:
					$Mushroom.visible = true
