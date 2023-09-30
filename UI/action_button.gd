extends MarginContainer
signal toggled(button_pressed)

@export var action_type : Global.ActionType = Global.ActionType.DESTROY
var pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if action_type != Global.ActionType.END_TURN:
		Global.action_points_changed.connect(_ap_changed)
	$Button.connect("toggled", _on_button_toggled)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_button_toggled(button_pressed):
	pressed = button_pressed
	toggled.emit(button_pressed)

func _ap_changed(new_ap):
	$Button.disabled = (new_ap <= 0)
