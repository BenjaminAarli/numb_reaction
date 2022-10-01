extends "res://Cogs/cogBlank.gd"

var text = null
var end = -1

var options = []

signal world_updated
signal self_updated 

func _ready():
	if text != null:
		$Movable/Addons/text.text = text

func _on_text_text_changed(new_text):
	text = new_text
	pass

func update_data(data):
	pass
