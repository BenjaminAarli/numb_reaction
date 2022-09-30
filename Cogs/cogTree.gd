extends "res://Cogs/cogBlank.gd"


var text = null
var end = -1

func _ready():
	type = Data.COG_TYPE_TREE
	if text != null:
		$Movable/Addons/text.text = text

func get_data():
	var text = str($Movable/Addons/text.text)
	
	var data = {}
	data["type"] 	= str(type)
	data["text"] 	= text if text.length() > 0 else ""
	return data

func set_data(data):
#	type = data["type"] # Probably don't need this.
	$Movable/Addons/text.text = data["text"]
	pass
