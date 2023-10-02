extends HBoxContainer

@export var on_mod = Color("5eff00")
@export var off_mod = Color("535353")

var tweens = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.action_points_changed.connect(update)

func _set_mod(point, threshold, node):
	if point < threshold:
		var t = create_tween()
		tweens[node] = t
		t.tween_property(node, "modulate", off_mod, 0.2)
	if point >= threshold:
		var t = create_tween()
		tweens[node] = t
		t.tween_property(node, "modulate", on_mod, 0.2)

func update(points):
	_set_mod(points, 1, $AP1)
	_set_mod(points, 2, $AP2)
	_set_mod(points, 3, $AP3)
	_set_mod(points, 4, $AP4)
	_set_mod(points, 5, $AP5)
