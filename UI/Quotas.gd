extends VBoxContainer

var _quotaItems: Dictionary = {}

# Called when the node enters the scene tree for the first time.
func _ready():
	var quotaItemScene = preload("res://UI/quota_item.tscn")
	for type in Global.ProduceType.values():
		var quotaItem = quotaItemScene.instantiate()
		quotaItem.type = type
		_quotaItems[type] = quotaItem
		add_child(quotaItem)
		
	Global.inventory_updated.connect(update)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func update():
	for key in _quotaItems.keys():
		var item = _quotaItems[key]
		item.update(Global.get_produce_name(key), Global.get_produce_count(key), Global.get_quota_count(key))
