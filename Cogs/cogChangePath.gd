extends "res://Cogs/cogBaseLine.gd"

# options exists
var path = ""

func _ready():
	type = Data.COG_TYPE_CHANGE_PATH
	pass

func get_data():
	var text = str($Movable/Addons/text.text)
	
	var data = {}
	data["type"] 	= str(type)
	data["text"] 	= text if text.length() > 0 else ""
	data["path"]	= path
	return data

func set_data(data):
#	type = data["type"] # Probably don't need this.
	$Movable/Addons/text.text = data["text"]
	pass

func new_data(data = []):
	var paths = data
	$Movable/Addons/OptionButton.clear()
	for o in paths:
		$Movable/Addons/OptionButton.add_item(o)
	pass

func update_data(data):
	if data != null:
		new_data(data.paths)
	pass


