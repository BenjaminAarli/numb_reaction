extends Node

var current_tree   = []
var current_branch = []
var current_check  = []

var current_success = []
var current_failure = []

var gen_file = {}

## STATS 
# Reason
# Wisdom
# Mechanist or meche
# Horror

func _ready():
	pass

## Adders

func startfile():
	gen_file.clear()
	var data = {
		"labels":{},
	}
	gen_file["data"] = data
	return data

func addblock(data):
	match data.type: 
		Data.COG_TYPE_TEXT:
			var spkr = data.speaker if data.speaker != null else ""
			addtext(data.text, spkr)
		Data.COG_TYPE_BRANCH:
			# CHANGE LATER cause this dosn't work for some reason. 
			# Check the gameplay stuff
			var t = data.text if data.text != null else ""
			var gt_t = data.goto_tree if data.goto_tree != null else false
			var cond = data.conditions if data.conditions != null else []
			
			addbranch(t, gt_t, cond)
		Data.COG_TYPE_TREE:
			addtree(data.text)
		Data.COG_TYPE_TREE_END:
			end_tree()
	pass

func addtext(text = "", speaker = ""):
	var list_num = gen_file.size()
	
	# Add to file
	var data = cog_text.new()
	data.speaker = speaker
	if speaker.length() > 0:
		data.speaker = speaker.to_upper()
	
	data.text = text
	# if in tree or branch.
	data.tree = current_tree.back() if current_tree.size() > 0 else null
	data.branch = current_branch.back() if current_branch.size() > 0 else null
	gen_file[list_num] = data
	return data

func addtree(text = ""):
	var list_num = gen_file.size()
	# Set current_tree to this tree.
	
	if text == null:
		text = ""
	
	current_tree.append(list_num)
	current_branch.append(-1) # Set that new branch should exist but make it empty. Aka "-1"
	# Add to file
	var data = cog_tree.new()
	data.text = text
	data.tree = current_tree.back() if current_tree.size() > 0 else null
	data.branch = current_branch.back() if current_branch.size() > 0 else null
	gen_file[list_num] = data
	return data

func addbranch(text = "", goto_tree = true, conditions = []):
	var list_num = gen_file.size()
	var previous_list = gen_file[list_num - 1]
	var tree = gen_file[current_tree[-1]] # Get tree from file
	# Branch Stuff
	## Get previous branch if branch exists. Used as an END point for previous branch. if branch is empty, aka -1, then dont set the end.
	var previous_branch = null if current_branch[-1] == -1 else gen_file[current_branch.back()] # get previous branch if not empty
	## if a previous branch was found, set it's END as here. 
	if previous_branch != null:
		previous_list.isBranchEnd = true
		previous_branch.end = list_num
	## Then set the current branch as this one.
	current_branch[-1] = list_num # Set current branch - We don't append because that would be for a tree inside a tree so we set it instead.
	# Tree stuff
	tree.branch_pos.append(list_num) # Set this list position. It's where meta_clicked should Goto onclick.
	# Add to file
	var data  = cog_branch.new()
	data.text = text
	data.conditions = conditions
	data.goto_tree  = goto_tree
	data.tree   = current_tree.back() if current_tree.size() > 0 else null
	data.branch = current_branch.back() if current_branch.size() > 0 else null
	gen_file[list_num] = data
	# add_to_tree
	tree.branches.append(data)
	tree.branch_text.append(text)
	# Text
	var color_text = "[color=#f46B17]"   + text       + "[/color]"
	var meta_text  = "[url={click_num}]" + color_text + "[/url]"
	var click_data = list_num
#	meta_text.push_meta(click_data)
	var ready_text = meta_text.replace("click_num", click_data) # Set for meta onclick
	tree.branch_names.append(ready_text)
	return data

func end_tree():
	# position in list at time of creation.
	var list_num = gen_file.size()
	var previous_list = gen_file[list_num - 1]
	var previous_branch = null if current_branch[-1] == -1 else gen_file[current_branch.back()]
	
	if previous_branch != null:
		previous_list.isBranchEnd = true
		previous_branch.end = list_num
		pass
	
	var tree = gen_file[current_tree.back()]
	tree.end = list_num
	
	# Add to file
	var data = cog_tree_end.new()
	data.text = "! Tree end !"
	data.tree = current_tree.back() if current_tree.size() > 0 else null
	data.branch = current_branch.back() if current_branch.size() > 0 else null
	data.isTreeEnd = true
	gen_file[list_num] = data
	
	current_branch.pop_back()
	current_tree.pop_back()
	return data

func changebg(source, fade = true, speed = 1):
	var list_num = gen_file.size()
	var data = cog_changebg.new()
	data.source = source
	data.fade_inout = fade
	data.speed = speed
	gen_file[list_num] = data
	return data

func setlabel(text: String):
	var list_num = gen_file.size()
	var data = cog_label.new()
	data.text = text
	gen_file["data"].labels[text] = list_num
	gen_file[list_num] = data
	return data

func addgoto(text: String):
	var list_num = gen_file.size()
	var data = cog_goto.new()
	data.text = text
	gen_file[list_num] = data
	return data

func addstatcheck(stat = "", dc = -1):
	var list_num = gen_file.size()
	var data = cog_statcheck.new()
	data.stat = stat
	data.dc = dc
	gen_file[list_num] = data
	current_check.append(list_num)
	return data

func adddicecheck(stat = "", dc = -1):
	var list_num = gen_file.size()
	var data = cog_dicecheck.new()
	data.stat = stat
	data.dc = dc
	gen_file[list_num] = data
	current_check.append(list_num)
	return data

func success_path():
	var list_num = gen_file.size()
	var data = cog_check_success.new()
	
	current_success.append(list_num)
	
	gen_file[list_num] = data
	return data

func failure_path():
	var list_num = gen_file.size()
	var data = cog_check_failure.new()
	
	current_failure.append(list_num)
	
	gen_file[list_num] = data
	return data

func end_check():
	var list_num = gen_file.size()
	
	var data = cog_check_end.new()
	gen_file[list_num] = data
	
	if current_check.size() == current_success.size(): # Set end of success if success exists
		gen_file[current_success.back()].end = list_num
		current_success.pop_back()
	if current_check.size() == current_failure.size(): # Set end of failure if failure exists
		gen_file[current_failure.back()].end = list_num 
		current_failure.pop_back()
	
	gen_file[current_check.back()].end = list_num # Set end of check branch
	current_check.pop_back()
	return data

func addpassivecheck(stat, dc, success_text = "", failure_text = ""):
	var list_num = gen_file.size()
	var data  = cog_statcheck_passive.new()
	data.stat = stat
	data.dc   = dc
	data.success_text = success_text
	data.failure_text = failure_text
	gen_file[list_num] = data
	current_check.append(list_num) # add as a check.
	return data

## ----------------------- ##

class cog:
	var tree 		= null
	var branch 		= null
	var isBranchEnd = false
	var isTreeEnd 	= false
	func get_data():
		return inst2dict(self)
	pass

class cog_text extends cog:
	var type = Data.COG_TYPE_TEXT
	var text = "I am text"
	var speaker = ""
	var speaker_text = ""
	pass

class cog_tree extends cog:
	var type = Data.COG_TYPE_TREE
	var text = "I am a question"
	var end = -1
	var branch_names = []
	var branch_pos   = []
	var branch_text  = []
	var branches     = []
	pass

class cog_branch extends cog:
	var type = Data.COG_TYPE_BRANCH
	var text = "I am an answer"
	var conditions = []
	var end = -1
	var goto_tree = false
	pass

class cog_tree_end extends cog:
	var type = Data.COG_TYPE_TREE_END
	var text = " - - tree end"

	pass

class cog_goto extends cog: # goes to label
	var type = Data.COG_TYPE_GOTO
	var text = "unlabeled"
	pass

class cog_label extends cog:
	var type = Data.COG_TYPE_LABEL
	var text = "unlabeled"
	pass

class cog_changebg extends cog:
	var type = Data.COG_TYPE_CHANGEBG
	var source     = ""
	var fade_inout = true
	var speed      = 1
	pass

class cog_dicecheck extends cog:
	var type = Data.COG_TYPE_DICECHECK
	
	var dc   = -1
	var stat = ""
	var success_path = null
	var failure_path = null
	var end = -1

	pass

class cog_statcheck extends cog:
	var type = Data.COG_TYPE_STATCHECK
	var dc   = -1
	var stat = ""
	var success_path = null
	var failure_path = null
	var end = -1
	pass

class cog_check_success extends cog:
	var type = Data.COG_TYPE_CHECK_SUCCESS
	
	var end = -1
	pass

class cog_check_failure extends cog:
	var type = Data.COG_TYPE_CHECK_FAILURE
	
	var end = -1
	pass

class cog_check_end extends cog:
	var type = Data.COG_TYPE_CHECK_END
	
	var end = -1
	pass

# Not added in interpreter.

class cog_statcheck_passive extends cog:
	var type = Data.COG_TYPE_CHECK_PASSIVE
	var dc   = -1
	var stat = ""
	var success_text = ""
	var failure_text = ""
	var success_path = null
	var failure_path = null
	var end = -1
	pass



































#
