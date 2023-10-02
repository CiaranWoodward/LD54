extends Label

var Days = ["Sunday", "Monday", "Tuesday", "Wednesday", "Thursday", "Saturday"]

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.day_changed.connect(update)

func update(day: int):
	text = Days[day % 7]
