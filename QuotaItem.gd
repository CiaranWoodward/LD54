extends HBoxContainer

var checked: bool = false
var type: Global.ProduceType

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update(name: String, actual: int, required: int): 
	$Count.text = "{actual}/{required}".format({"actual": actual, "required": required})
	$Name.text = name