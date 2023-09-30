extends MarginContainer
signal toggled(button_pressed)

var action_type : Global.ActionType = Global.ActionType.PLANT
@export var plant_type : Global.PlantType
var pressed : bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = Global.get_plant_name(plant_type)
	$Button.tooltip_text = Global.get_plant_description(plant_type)
	Global.inventory_updated.connect(update_count)
	update_count()

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
