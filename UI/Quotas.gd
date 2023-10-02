extends VBoxContainer

var _quotaItems: Dictionary = {}
var _extras_label : Label = Label.new()

# Called when the node enters the scene tree for the first time.
func _ready():
	var quotaItemScene = preload("res://UI/quota_item.tscn")
	for type in Global.ProduceType.values():
		var quotaItem = quotaItemScene.instantiate()
		quotaItem.type = type
		_quotaItems[type] = quotaItem
		add_child(quotaItem)
	add_child(_extras_label)
		
	Global.inventory_updated.connect(update)
	update()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update():
	var extra_text = ""
	for key in _quotaItems.keys():
		var item = _quotaItems[key]
		var pname = Global.get_produce_name(key)
		var q = Global.get_quota_count(key)
		var c = Global.get_produce_count(key)
		item.update(pname, c, q)
		if q == 0 && c > 0:
			extra_text += "\n " + str(c) + " " + pname
	if extra_text:
		_extras_label.text = "Surplus:" + extra_text
	else:
		_extras_label.text = ""
