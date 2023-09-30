extends MarginContainer

@export var plant_type : Global.PlantType

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
