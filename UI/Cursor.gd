extends Node2D

signal interacted_with_tile(tile : PlantTile)

@export var idle_color : Color = Color.WHITE
@export var invalid_color : Color = Color.WHITE
@export var valid_color : Color = Color.WHITE

var _current_action = Global.ActionType.NONE
var _current_plant
var _current_plantinstance
var _current_tile: PlantTile
var _mouse_pressed = false
var _move_tween

var clear_action_func : Callable

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _unhandled_input(event):
	if event is InputEventMouseButton && (event.button_index == MOUSE_BUTTON_LEFT):
		var e = event as InputEventMouseButton
		if e.is_pressed():
			_mouse_pressed = true
		else:
			if _mouse_pressed:
				_apply_action()
			_mouse_pressed = false

func set_current_tile(currentTile : PlantTile):
	if _current_tile == currentTile:
		return
	if !is_instance_valid(currentTile):
		self.visible = false
		_current_tile = null
		return
	if self.visible:
		_move_tween = create_tween()
		_move_tween.tween_property(self, "global_position", currentTile.global_position, 0.1).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
	else:
		self.global_position = currentTile.global_position
	self.visible = true
	_current_tile = currentTile
	if _current_action == Global.ActionType.PLANT:
		if _current_plantinstance.can_sow(currentTile):
			modulate = valid_color
		else:
			modulate = invalid_color
	elif _current_action == Global.ActionType.HARVEST:
		var plant: BasePlant = _current_tile.child_plant
		if is_instance_valid(plant):
			if is_instance_valid(plant.hosted_plant):
				plant = plant.hosted_plant
			if (plant.can_harvest()):
				modulate = valid_color
				var to_harvest = plant.harvest_description()
				$Harvest/PanelContainer/MarginContainer/VBoxContainer/ToHarvest.text = "{name}: {amount}".format(to_harvest)
				$Harvest/PanelContainer.visible = true
			else:
				modulate = invalid_color
				$Harvest/PanelContainer.visible = false
		else:
			modulate = invalid_color
			$Harvest/PanelContainer.visible = false
	elif _current_action == Global.ActionType.DESTROY:
		if is_instance_valid(_current_tile.child_plant):
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

func _apply_action():
	if !is_instance_valid(_current_tile) || _current_action == Global.ActionType.NONE:
		return
	match (_current_action):
		Global.ActionType.DESTROY:
			if !is_instance_valid(_current_tile.child_plant):
				return
			_current_tile.child_plant.destroy()
			if is_instance_valid(_current_tile.child_plant) && _current_tile.child_plant.can_harvest():
				modulate = valid_color
			else:
				modulate = invalid_color
		Global.ActionType.HARVEST:
			if !is_instance_valid(_current_tile.child_plant):
				return
			if !_current_tile.child_plant.can_harvest():
				return
			if is_instance_valid(_current_tile.child_plant.hosted_plant):
				_current_tile.child_plant.hosted_plant.harvest()
			else:
				_current_tile.child_plant.harvest()
			var plant: BasePlant = _current_tile.child_plant
			if is_instance_valid(plant):
				if is_instance_valid(plant.hosted_plant):
					plant = plant.hosted_plant
				if (plant.can_harvest()):
					modulate = valid_color
					var to_harvest = plant.harvest_description()
					$Harvest/PanelContainer/MarginContainer/VBoxContainer/ToHarvest.text = "{name}: {amount}".format(to_harvest)
					$Harvest/PanelContainer.visible = true
				else:
					modulate = invalid_color
					$Harvest/PanelContainer.visible = false
			else:
				modulate = invalid_color
				$Harvest/PanelContainer.visible = false
		Global.ActionType.PLANT:
			if !_current_plantinstance.can_sow(_current_tile):
				return
			_current_plantinstance.sow(_current_tile)
			if Global.get_seed_count(_current_plant) == 0:
				clear_action_func.call()
			else:
				update_action()
	interacted_with_tile.emit(_current_tile)
	Global.action_points -= 1
	if Global.action_points == 0:
		clear_action_func.call()
