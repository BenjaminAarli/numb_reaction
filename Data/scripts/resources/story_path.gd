class_name numb_path
extends Resource

export(String) var display_name = ""

export(Array) var story = []

func get_data():
	var data = {
		"display_name" : display_name,
		"story" : story
	}
	return data
