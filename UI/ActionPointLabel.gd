extends Label

@export var template = "AP: {points}"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.action_points_changed.connect(update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update(points):
	text = template.format({"points": points})
