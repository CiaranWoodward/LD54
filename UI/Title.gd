extends Label

@export var template = "Quota ({days} days left)"
@export var today = "Quota (today)"

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.day_changed.connect(update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update(day: int):
	var left: int = 7 - (day % 7)
	text = template.format({"days": left}) if left > 1 else today
