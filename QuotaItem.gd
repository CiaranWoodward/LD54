extends HBoxContainer

var checked: bool = false
var type: Global.ProduceType

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.new_quota.connect(new_quota)
	$Checkbox.uncheck()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func new_quota():
	checked = false
	$Checkbox.uncheck()

func update(name_: String, actual: int, required: int):
	visible = !(required == 0)
	$Count.text = "{actual}/{required}".format({"actual": actual, "required": required})
	$Name.text = name_
	if !checked && actual >= required:
		checked = true
		$Checkbox.check()
	elif actual < required:
		$Checkbox.uncheck()
		checked = false
		
