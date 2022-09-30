extends "res://Cogs/cogBlank.gd"

# For File
var text = null
var speaker = null

func _ready():
	type = Data.COG_TYPE_TEXT
	if text != null:
		$Movable/Addons/text.text = text
	if speaker != null:
		$Movable/Addons/speaker.text = speaker
	pass

func update_data(_data):
	pass

func get_data():
	var _speaker = str($Movable/Addons/speaker.text)
	var _text = str($Movable/Addons/text.text)
	
	var data = {}
	data["type"] 	= str(type)
	data["speaker"] = _speaker if _speaker.length() > 0 else ""
	data["text"] 	= _text
	return data

func set_data(data):
#	type = data["type"] # Probably don't need this.
	$Movable/Addons/speaker.text = data["speaker"]
	$Movable/Addons/text.text = data["text"]
	pass
