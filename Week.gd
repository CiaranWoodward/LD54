extends Label

@export var template: String = "Week {week}"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.day_changed.connect(update)

func update(day: int):
	text = template.format({"week": ceili(day / 7) + 1})
