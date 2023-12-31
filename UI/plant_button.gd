extends MarginContainer
signal toggled(button_pressed)

var action_type : Global.ActionType = Global.ActionType.PLANT
@export var plant_type : Global.PlantType
var pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Label.text = Global.get_plant_name(plant_type)
	$Button.tooltip_text = Global.get_plant_description(plant_type)
	Global.action_points_changed.connect(_ap_changed)
	Global.inventory_updated.connect(update_count)
	update_count()
	var typename = Global.PlantType.keys()[plant_type]
	for child in $Button/Control.get_children():
		child.visible = child.name == typename

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_count():
	var count = Global.get_seed_count(plant_type)
	$Count.text = str(count)
	self.visible = (count > 0)

func _on_button_toggled(button_pressed):
	pressed = button_pressed
	toggled.emit(button_pressed)

func _ap_changed(new_ap):
	$Button.disabled = (new_ap <= 0)
