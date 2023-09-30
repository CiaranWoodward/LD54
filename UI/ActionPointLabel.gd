extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.action_points_changed.connect(update)
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update(points):
	text = "AP: {points}".format({"points": points})
