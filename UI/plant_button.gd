extends MarginContainer

@export var plant_type : Global.PlantType

# Called when the node enters the scene tree for the first time.
func _ready():
	$Button.text = Global.get_plant_name(plant_type)
	$Button.tooltip_text = Global.get_plant_description(plant_type)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
