extends Node

# Parts
onready var Textbox = $TextDisplay/RichTextLabel
onready var BGImage = $BGs/Image
onready var BGVideo = $BGs/Video
onready var anim    = $AnimationPlayer
onready var Speaker = $TextDisplay/SpeakerNode/Speaker
onready var SpeakerNode = $TextDisplay/SpeakerNode

var setting_clock_active = true

var wait_for_player_input = false # When in tree, wait for response

var file

var current_tree = []
var current_line = 0

var next_up = null # for going forward without moving forward

## Player Stats
var reason = 4
var wisdom = 4
var horror = 4
var machine = 4

var current_answers = {}

func _ready():
	$TextDisplay/btn_ClockActivator.connect("button_down", self, "activate_clock")
	
	$AnimationPlayer.play("startup")
	Textbox.connect("meta_clicked", self, "answer_clicked")
	$TextDisplay/Button.connect("button_down", self, "next")
	if Data.intro_file != null:
		file = Data.intro_file
	
	# For testing! Used when I want to skip to a part in the current path.
	if Data.testing_current_line != null: 
		current_line = Data.testing_current_line
	
	check_file()
	print("FILE : ", file)
	
	wait_for_player_input = true
	yield($AnimationPlayer, "animation_finished")
	wait_for_player_input = false
	pass

func next():
	if not wait_for_player_input:
		if Textbox.percent_visible != 1:
			visible_chars = Textbox.get_total_character_count()
			Textbox.percent_visible = 1
		else:
			if not isFileEnd(current_line):
				next_line()
			else:
				print(" ! END OF FILE ! ")
			pass

func answer_clicked(answer): 
	wait_for_player_input = false
	read("[color=#fff]" + current_answers[int(answer)] + "[/color]")
	current_answers = {}
	next_line(int(answer))
	pass

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept") and not wait_for_player_input:
			next()

var visible_chars = 0
var text_grow_speed = 8 * 4

func activate_clock():
	setting_clock_active = !setting_clock_active
	pass

func _process(delta):
	var lenght = Textbox.text.length()
	
	# This code is gross, but does the job.
	if Textbox.percent_visible < 1:
		visible_chars += text_grow_speed * delta
	else:
		Textbox.percent_visible = 1
	Textbox.visible_characters = visible_chars
	pass

func check_file():
	for x in 9:
		read("\n\n") # This is for the text starting point. Makes it the bottom.
	if file == null:
		printerr("GameSystem Error: No File found, please insert file.")
		read("No file found")
	else:
		read("Press SPACE to start")
	pass

func next_line(next = null):
	
	current_line += 1
	
	if next != null:
		current_line = next
	
	if next_up != null: # for setting next without executing this function. 
		current_line = next_up
		next_up = null
	
	var branch = file[current_line].branch if file[current_line].branch != null else null
	var tree   = file[current_line].tree   if file[current_line].tree   != null else null
	
	if isTreeEnd(current_line):
		# This is just to make sure that the next...
		# ... line isn't a branch. if so, skip to it's tree.
		if not isFileEnd(current_line + 1): # make sure its not the end of the file
			var nline = file[current_line + 1] # next line = nline. next_line and next was taken.
			if nline.type == Data.COG_TYPE_BRANCH:
				next_up = nline.tree if nline.tree != null else null
		next_line()
	
	if isBranchEnd(current_line):
		onBranchEnd(current_line)
	print("FIND VALUE FUCK YOU! : ", file.values()[current_line].get_data())
	do_line(file.values()[current_line])
	pass

func onBranchEnd(current_line): # this is what to do if its branch's end.
	var branch = file[current_line].branch if file[current_line].branch != null else null
	var tree   = file[current_line].tree   if file[current_line].tree   != null else null
	
	if branch != null and file[branch].goto_tree: 
		# Branch: GoTo Tree.
		next_up = file[current_line].tree
	else: 
		# Branch: Continue from end of tree
		var path
		if tree != null:
			path = file[tree].end
		
		next_up = path
	pass

func do_line(LINE):
	match LINE.type:
		Data.COG_TYPE_TEXT:
			read(LINE.text, true, LINE.speaker)
			print(LINE.text)
		Data.COG_TYPE_BRANCH:
			next_line()
		Data.COG_TYPE_TREE:
			onTree()
		Data.COG_TYPE_GOTO:
			var goto = file["data"].labels[LINE.text]
			next_line(goto)
			pass
		Data.COG_TYPE_LABEL:
			next_line()
			pass
		Data.COG_TYPE_CHANGEBG:
			if LINE.fade_inout:
				fade_image(LINE)
			else:
				changeBG(LINE.source)
			next_line()
		Data.COG_TYPE_DICECHECK:
			dicecheck(LINE)
		Data.COG_TYPE_STATCHECK:
			statcheck(LINE)
		Data.COG_TYPE_CHECK_PASSIVE:
			passive_check(LINE)
		Data.COG_TYPE_CHECK_SUCCESS:
			check_success(LINE)
		Data.COG_TYPE_CHECK_FAILURE:
			check_failure(LINE)
	pass

func stat_value(stat):
	return get(str(stat).to_lower())

func check_success(data):
	next_line(data.end)
	pass

func check_failure(data):
	next_line(data.end)
	pass

func passive_check(data):
	var stat = stat_value(data.stat)
	var dc   = data.dc
	
	# Success
	if stat >= dc: # Success
		if data.success_text != "": 
			read(data.success_text)
		if data.success_path != -1:
			print("Passive_check: Success Path: " + str(data.success_path))
			next_line(data.success_path + 1)
	# Failure
	if stat <  dc: # Failure
		if data.failure_text != "":
			read(data.failure_text)
		if data.failure_path != -1:
			next_line(data.failure_path + 1)
	pass

func onTree():
	wait_for_player_input = true
	current_tree.append(current_line)
	var tree = file[current_tree.back()]
	# read the tree question.
	read("\n\n" + tree.text + "\n")
	# read the answers
	
	var t = ""
	for answer in range(tree.branch_names.size()):
		current_answers[tree.branch_pos[answer]] = "[color=#444]" + '"' + tree.branch_text[answer] + '"' + "[/color]"
		read(tree.branch_names[answer], false)
	pass

var previous_text = ""
func commit_to_textbox(text: String):
	Textbox.bbcode_text = "[color=#666]" + Textbox.text + "[/color]" # Text sterilizer. Removes all [url]'s and other [func] functions
	previous_text = text
	pass

## Text 1
## Text 2 
# Dont commit me
# Don't commit me either
## Text 3... 

var unsterilized_text = ""
var has_uncommited_text = false
func read(string: String, sterilize = true, speaker = ""): # Sterilize means convert bbcode to normal text
	if speaker.length() > 0:
		SpeakerNode.show()
		Speaker.self_modulate = Color.white
		match speaker.to_upper():
			_:
				Speaker.self_modulate = Color.white
				Speaker.texture = null
				continue
			Data.stat.abyss:
				Speaker.texture = load("res://images/skills_cc/V2/Horror.png")
				Speaker.self_modulate = Color.brown
			Data.stat.reason:
				Speaker.texture = load("res://images/skills_cc/V2/Horror.png")
				Speaker.self_modulate = Color.webgreen
			Data.stat.wisdom:
				Speaker.texture = load("res://images/skills_cc/V2/Machine.png")
				Speaker.self_modulate = Color.aqua
			Data.stat.meche:
				Speaker.texture = load("res://images/skills_cc/V2/Machine.png")
				Speaker.self_modulate = Color.darkslategray
	else:
		Speaker.texture = null
		Speaker.self_modulate = Color.white
		SpeakerNode.hide()
		pass
	
	if sterilize:
		if has_uncommited_text == true:
			Textbox.bbcode_text = unsterilized_text
			has_uncommited_text = false
	if not sterilize:
		if not has_uncommited_text:
			unsterilized_text = Textbox.bbcode_text
		has_uncommited_text = true
	
	var spacing = "\n\n"
	if sterilize:
		spacing += spacing
	
	var spoke = ""
	if speaker.length() > 0:
		spoke = "[b][color=#f00]" + speaker + " - [/color][/b]"
	Textbox.bbcode_text += spacing + spoke + string
	pass

func fade_to_image():
	anim.play("fade_to_image")
	pass

func fade_to_black():
	anim.play("fade_to_black")
	pass

func fade_image(data):
	wait_for_player_input = true
	fade_to_black()
	anim.playback_speed = data.speed
	yield(anim, "animation_finished")
	changeBG(data.source)
	fade_to_image()
	yield(anim, "animation_finished")
	next_line()
	wait_for_player_input = false
	pass

# Cog Functions

func dicecheck(data):
	randomize()
	var stat = stat_value(str(data.stat).to_lower())
	var dc = data.dc
	# Diceroll
	var d1 = round(rand_range(0.51, 6.49))
	var d2 = round(rand_range(0.51, 6.49))
	var dsum = d1 + d2
	var sum = dsum + stat
	# Dicecheck vs stat + diceroll
	var result = true if sum >= dc else false
	# Go to path.
	if result:
		read("[color=#273]Diceroll: Success. "+"("+str(d1)+" + "+str(d2)+" + stat ("+str(data.stat)+")"+str(stat)+" = "+str(sum)+") vs "+" ("+ str(data.dc)+")[/color]", false)
		next_line(data.success_path)
	else:
		read("[color=#723]Diceroll: Failure. "+"("+str(d1)+" + "+str(d2)+" + stat ("+str(data.stat)+")"+str(stat)+" = "+str(sum)+") vs "+" ("+ str(data.dc)+")[/color]", false)
		next_line(data.failure_path)
	pass

func statcheck(data):
	pass

func GoTo(data):
	
	# FIX LATER - MAKE WORK. I am depressed
	
	if file["filedata"].labels.has(data.text):
		pass
	pass

# UI Functions

func changeBG(source):
	var BGImage = $BGs/Image
	var BGVideo = $BGs/Video
	var newBG = load(source) if source != null else null # Get image or video
	var type = newBG.get_property_list()[6]["name"] if source != null else null # Get resource type name (Texture or VideoStream)
	
	if type == "Texture":
		BGVideo.hide()
		BGImage.show()
		BGImage.texture = newBG
	elif type == "VideoStream":
		BGImage.hide()
		BGVideo.show()
		BGVideo.stream  = newBG
	else:
		BGImage.hide()
		BGVideo.hide()
	pass
# Helper Functions # 

func isFileEnd(num: int):
	# in case file is missing
	if file == null:
		return true
	# in case end of file
	if num < file.size () - 1:
		return false
	else:
		return true
	pass

func isBranchEnd(num: int):
	return file[num].isBranchEnd

func isTreeEnd(num: int):
	return file[num].isTreeEnd

