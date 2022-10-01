extends "res://GameSystem/scripts/CogSystem.gd"

var game_scn = preload("res://GameSystem/scn_game.tscn")

onready var btnFile := $Buttons/Panel2/btnFileMenu
onready var gridcont := get_node("Editor/ScrollContainer/GridContainer")
onready var saveFileDialogue := $Control/SaveFileDialogue
onready var loadFileDialogue := $Control/loadFileDialogue
onready var confirmationDialogue := $Control/ConfirmationDialog

onready var charactar_node := $Other/TabContainer/Characters

var file_save_path = "res://Data/game/"
var file_save_name = "NumbReaction"

signal file_data_has_changed(data)
signal file_loaded()

var isFileSaved = false

func _ready():
	btnFile.get_popup().connect("index_pressed", self, "btnFileMenuIDPressed")
	pass

var selected_child = null
var selected_position = null
var mouse_text = ""

func _process(delta):
	$Mouse/Label.text = str(mouse_text)
	pass

func update_list_data(data = null):
	if data != null:
		print("UPDATE LIST DATA: ", data)
	
	if gridcont == null:
		return 0
	if gridcont.get_child_count() > 1:
		for c in gridcont.get_children():
			c.data_characters = Data.ed_characters
			c.data_paths = Data.ed_paths
			c.update_data(data)
	pass

func clear_list():
	for c in gridcont.get_children():
		c.queue_free()
	pass

func new_file():
	clear_list()
	pass

func get_current_path():
	var current_path = []
	# Go through each text block (or other) and get their data.
	for c in gridcont.get_children():
		current_path.append(c.get_data())
	return current_path

func array_to_path(arr):
	clear_list()
	gridcont.generate_cogwheel_using_file(arr)
	pass

func save_file():
	if file_save_path == null:
		save_file_as()
		return 0
	
	var current_path = get_current_path()
	
	var dir = Directory.new()
	dir.open(file_save_path)
	var dir_exists = dir.file_exists(file_save_name)
	
	if not dir_exists:
		dir.make_dir(file_save_name)
		pass
	
	# Create new story file
	var file = numb_story.new()
	# Get the characters from the character_creator node
	file.characters = charactar_node.get_all_characters()
	# Get the cogs and add them to a story path
	file.paths["intro"] = current_path
	# save it all
	ResourceSaver.save(file_save_path + "/" +  file_save_name + "/" + file_save_name + ".tres", file)
	pass

func save_file_as():
#	saveFileDialogue.current_path = "res://story_scripts/"
#	saveFileDialogue.popup_centered(Vector2(800, 600))
	pass

func load_file():
	var load_file = ResourceLoader.load(file_save_path + "/" +  file_save_name + ".tres")
	pass

func load_file_loader(file):
	# LOADING FILE
	var loadfile = File.new()
	loadfile.open(file_save_path + "/" +  file_save_name, File.READ)
	
	var loadf = loadfile.get_var(true)
	
	loadfile.close()
	# LOAD FILE END
	
	print(loadf)
	
	gridcont.generate_cogwheel_using_file(loadf)
	update_list_data()
	emit_signal("file_loaded")
	pass

func test_full_file():
	Data.intro_file = unparsed_file
	get_tree().change_scene("res://GameSystem/scn_game.tscn")
	pass

func btnFileMenuIDPressed(id):
	var id_2_text = str(btnFile.get_popup().get_item_text(id)).to_lower() # Made to lower for easier comparison.
	
	match id_2_text:
		"new file":
			new_file()
		"save file":
			save_file()
		"save file as":
			save_file_as()
		"load file":
			load_file()
		"exit editor":
			exit_editor()
	pass

func exit_editor():
	print("Exited the editor. ")
	pass

func _on_btnFileMenu_toggled(button_pressed):
	print(str(button_pressed))
	pass

func _on_SaveFileDialogue_file_selected(path):
	file_save_path = path
	pass

func _on_SaveFileDialogue_confirmed():
	print($Control/SaveFileDialogue.current_path)
	print($Control/SaveFileDialogue.current_file)
	print($Control/SaveFileDialogue.current_dir)
	
	file_save_path = $Control/SaveFileDialogue.current_dir
	file_save_name = $Control/SaveFileDialogue.current_file
	
	save_file()
	pass

func _on_loadFileDialogue_confirmed():
	file_save_path = $Control/loadFileDialogue.current_dir
	file_save_name = $Control/loadFileDialogue.current_file
	
	load_file_loader(file_save_path)
	update_list_data()
	pass

func _on_btnSaveFile_pressed():
	save_file()
	pass

func _on_btnGenGameFile_pressed():
	pass

func _on_btnTestGameFile_pressed():
	startfile()
	for g in gridcont.get_children():
		addblock(g.get_data())
	Data.intro_file = unparsed_file
	test_full_file()
	pass

func _on_btnTestFromPosition_pressed():
	startfile()
	for g in gridcont.get_children():
		addblock(g)
	Data.testing_current_line = selected_position
	test_full_file()
	pass

func _on_btnLoadFile_pressed():
	load_file()
	update_list_data()
	emit_signal("file_loaded")
	pass


# DATA UPDATE SIGNALS # 

var all_data = {
	paths = [],
	chars = []
}

func _on_File_file_data_updated(data):
	update_list_data(all_data)
	pass 

func _on_Paths_path_data_updated(data):
	all_data.paths = data
	update_list_data(all_data)
	pass

func _on_Characters_character_data_updated(data):
	all_data.chars = data
	update_list_data(all_data)
	pass
