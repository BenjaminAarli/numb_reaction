extends Node

const COG_TYPE_TREE 	= "cog_type_tree"
const COG_TYPE_TREE_END = "cog_type_tree_end"
const COG_TYPE_BRANCH 	= "cog_type_branch"
const COG_TYPE_TEXT 	= "cog_type_text"
const COG_TYPE_GOTO 	= "cog_type_goto"
const COG_TYPE_LABEL 	= "cog_type_label"


# THIS SCRIPT WAS JUST TO COPY OVER SOME DETAILS. 
# i'm keeping it just in case the other one fails.


var file
var current = 0
var canContinue = true
var _trees = []
var next_up = null # for going forward without moving forward




func _ready():
	$RichTextLabel.connect("meta_clicked", self, "meta_click")
	$RichTextLabel.scroll_following = true
	
#	file = unparsed_file
	next_line()

func meta_click(meta):
	canContinue = true
	next_line(int(meta))
	pass

func _input(event):
	if event is InputEventKey:
		if Input.is_action_just_pressed("ui_accept") and canContinue:
			if not isFileEnd(current):
				next_line()
			else:
				print(" ! END OF FILE ! ")
			pass
	pass

func next_line(next = null):
	current += 1
	
	if next != null:
		current = next
	
	if next_up != null: # for setting next without executing this function. 
		current = next_up
		next_up = null
	
	var branch = file[current].branch if file[current].branch != null else null
	var tree   = file[current].tree   if file[current].tree   != null else null
	
	if isTreeEnd(current):
		# This is just to make sure that the next...
		# ... line isn't a branch. if so, skip to it's tree.
		if not isFileEnd(current + 1): # make sure its not the end of the file
			var nline = file[current + 1] # next line = nline. next_line and next was taken.
			if nline.type == COG_TYPE_BRANCH:
				next_up = nline.tree if nline.tree != null else null
		return next_line()
	
	if isBranchEnd(current):
		onBranchEnd(current)
	
	do_line(file.values()[current])
	pass

func onBranchEnd(current): # this is what to do if its branch's end.
	var branch = file[current].branch if file[current].branch != null else null
	var tree   = file[current].tree   if file[current].tree   != null else null
	
	if branch != null and file[branch].goto_tree: 
		# Branch: GoTo Tree.
		next_up = file[current].tree
	else: 
		# Branch: Continue from end of tree
		var path
		if tree != null:
			path = file[tree].end
		
		next_up = path
	pass

func do_line(LINE):
	match LINE.type:
		COG_TYPE_TEXT:
			write(LINE.text)
		COG_TYPE_BRANCH:
			next_line()
		COG_TYPE_TREE:
			tree_func()
		COG_TYPE_GOTO:
			var goto = file["data"].labels[LINE.text]
			print("GOTO: ", str(goto))
			next_line(goto)
			pass
		COG_TYPE_LABEL:
			print("LABEL HIT")
			next_line()
			pass
	pass

func tree_func():
	canContinue = false
	_trees.append(current)
	var tree = file[_trees.back()]
	# write the tree question.
	write("\n\n" + tree.text + "\n")
	# write the answers
	for answer in tree.branch_names:
		write(answer, false)
	pass


func write(text: String, sterilize = true):
	if sterilize:
		$RichTextLabel.bbcode_text = "[color=#888]" + $RichTextLabel.bbcode_text + "[/color]"
	
	$RichTextLabel.bbcode_text += "\n" + text
	pass

func isFileEnd(num: int):
	if num < file.size() - 1:
		return false
	else:
		return true
	pass

func isBranchEnd(num: int):
	return file[num].isBranchEnd

func isTreeEnd(num: int):
	return file[num].isTreeEnd
