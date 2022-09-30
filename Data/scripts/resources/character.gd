class_name numb_character
extends Resource

export(String) var fname = "Harrier Du Buis"
export(String) var display_name = "Harry"
export(String) var job_title = "Hierophant"

export(String, MULTILINE) var description = "This is a character description"

export(Texture) var portrait = null

export(Color) var nameColor = Color.black

export(Font) var nameFont = null
export(Font) var textFont = null

func get_data():
	var data = {}
	data.fname = fname
	data.display_name = display_name
	data.description = description
	data.portrait = portrait
	data.nameColor = nameColor
	data.nameFont = nameFont
	return data

func set_data(data):
	fname = data.fname
	display_name = data.display_name
	description = data.description
	portrait = data.portrait
	nameColor = data.nameColor
	nameFont = data.nameFont
	pass
