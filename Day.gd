extends Label

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.day_changed.connect(update)

func update(day: int):
	text = str((day % 7) + 1)
