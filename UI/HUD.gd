extends CanvasLayer

signal action_changed(newAction : Global.ActionType, plantType : Global.PlantType)

@onready var _buttons = $ActionPanel/HBoxContainer
var _current_action = Global.ActionType.NONE
var _current_plant = Global.PlantType.WEED

# Called when the node enters the scene tree for the first time.
func _ready():
	for child in _buttons.get_children():
		child.connect("toggled", _button_toggled)
		if child.name.contains("Plant"):
			child.connect("mouse_entered", func():
				if randi() % 2: $Sound/Tap1.play_rand()
				else: $Sound/Tap2.play_rand())
			child.connect("toggled", func(on):
				if !on: return
				if randi() % 2: $Sound/Tap1.play_rand()
				else: $Sound/Tap2.play_rand())

func set_show_action_panel(show_panel : bool):
	$ActionPanel.visible = show_panel
	$ActionCounter.visible = show_panel

func clear_action():
	var bg = load("res://UI/ActionButtonGroup.tres")
	for b in bg.get_buttons():
		b.button_pressed = false

func current_action():
	return _current_action

func selected_planttype():
	return _current_plant

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _button_toggled(state):
	for child in _buttons.get_children():
		if child.pressed:
			_current_action = child.action_type
			if "plant_type" in child:
				_current_plant = child.plant_type
			action_changed.emit(_current_action, _current_plant)
			return
	_current_action = Global.ActionType.NONE
	action_changed.emit(_current_action, _current_plant)
