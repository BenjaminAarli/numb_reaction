extends Node

var current_tree   = []
var current_branch = []
var current_check  = []

var current_success = []
var current_failure = []

var unparsed_file = {}

## STATS 
# Reason
# Wisdom
# Mechanist
# Horror

func _ready():
	print("File System is ready.")
	
	startfile()
	
	addtext("You wake up.")
	addtext("The sound is the fluorescent lightbulbs buzz like the flies that visit your concrete cage. The quiet murmurs of the other cells, bickering about the early exit of unconcienceness.")
	addtext("You feel it too. That painful sting in your eyes, the dry throat and the shaking from the adrenaline of being woken up. It's an emotion best compared to slow torture.")
	addtext("The guardsmen arrive at your cell to check if you are awake; and in seeing that you are, continue to the next cell for further inspection.")
	addtext("The guardsmen have a purple-ish, dark hue under their eyes combined with their calm and slow demeanor; The guardmen are tired.", "Reason")
	addtext("...yet this is beyond unrest. They are practically shaking. Their eyes tell stories of words from the outside. Whispered words.", "Reason")
	addtext("Something bad is happening, and you are stuck here. In this cell. Alone.", "Wisdom")
	addtext("You shuffle over to the cell door. Looking outside shows that you are not alone in doing so. Many inmates are at their doors, quietly waiting.")
	changebg("res://images/Factory_inside_old_07.png")
	addtext("The guardmen stands in the middle of the hallway, outside your cell. He's holding a piece of paper, clutched in his hands.")
	
	addtree("")
	addbranch("[ask the guardsmen] Are there word from outside?", false)
	addtext("The guardmen looks at you with his tired, angry expression. His demeanor is strict and uptight. Proud, yet defeated. He's not happy about this but follows his duties without question.", "Wisdom")
	addbranch("[stay quiet]", false)
	addtext("There is a moment of silence. This hasn't happenend before, but this is clearly bad news.")
	end_tree()
	
	addtext("The guardsmen holds up the paper as if reading a scroll of forbidden knowledge, and reads out loud.")
	addtext(str('"Due to a promotion of prisoner 1612 BA in Sector 97. As of 5 days ago, you are free of all previous crimes. Report to the tower at sector 97 to recieve your promotion within 3 days ago to recieve your assignment."'))
	addtext("The guardmen dosen't blink. He doesn't move. He doesn't breathe. He just stands there in complete silence as if he's trying to wake up from this nightmare.")
	addtext("... but there he stands, awake and alive. Note in hand, and turn to you.")
	addtext(str('"Prisoner 1612 BA. If you did not hear me loud and clear, a letter will be given to you as you are processed for release. Please step away from the cell door."'))
	addtext("You stagger away from the cell door, still unclear if this isn't just a wet dream. This feels unreal. Imagined. There is no way they will let you go. Why would they?")
	addtext("You are serving three consecutive life sentances. This is not a happy accident.", "Wisdom")
	addtext("Are they killing you? Taking you out to make room for younger, more capeable prisoners? You aren't that old, are you?", "Reason")
	addtext("We need a plan. Something that makes them question their morals, or perhaps make them afraid. Make them scared to take you out?", "Reason")
	addtree("")
	addbranch("Try to reason with them. There is always a deal to be made. They must need something. Anything.", true)
	addtext("You spend a few seconds considering your options. What we have, what we can do... there is little of anything. Perhaps...")
	addtext("Oh what, smartass? You think we have anything on them. These guardsmen are tired of everyones shit.", "Reason")
	addtext("Let's tell them we got half an energy bar and some nuts in our locker or we could talk about the morality of the situation.", "Reason")
	addtext("We left all of reasonable doubt once we walked through these doors, and even if we did...", "Reason")
	addtext("... we would have used it years ago. Reasoning isn't a path for you here. Never was.", "Reason")
	addbranch("Scare them. Your death is only the start of their demise. Make them fear what you will become.", true)
	addtext("You think of what scares you. What makes your spine chill. What hides in the depths of your mind.")
	addtext("You like to imagine this is easy but it's not. Your body is fragile and old; and your mind is not an improvement.", "Wisdom")
	addtext("The little control you have, is over a crumbling temple that you destroyed with many years of abuse and lack of self-control. You are no threat.", "Wisdom")
	addtext("...and the things you have done only speak volumes of how truely sorry of a person you are.", "Wisdom")
	addtext("If you want them scared, tell them you are ready to die; because out of everything...", "Wisdom")
	addtext("...that is what scares you most... but you would never admit that.", "Wisdom")
	addbranch("Your records show 'mentally unstable'. You can say something that makes them believe it.", true)
	addtext("You... you are insane. That's it. Mentally unstable and head on table. Claim you hear the voices of all the people they have killed or that you dream of their wives heads on pikes. ANyThinG! Quick!", "Horror")
	addtext("Claim immortality, or better - link your life with theirs. Claim if you die, they dissapear; as if the press of a button made them stop existing.", "Horror")
	addtext("No need for deception or lies. Tell the honest facts. Tell them you will return, smarter and stronger! Unless...", "Horror")
	addtext("We've been here before... we've tried all the other options...", "Horror")
	addtext("This... There is no changing this. The whispers are silent and await your end.", "Horror")
	addbranch("Ask to gamble. Your life is probably worth a roll of dice.")
	addtext("Hey, lets gamble?")
	addtext("Sure, why not.", "Guardsmen")
	adddicecheck("horror", 12)
	success_path()
	addtext("You won")
	failure_path()
	addtext("You lost")
	end_check()
	addtext("Alright, that was fun but now you come with us.", "Guardsmen")
	addpassivecheck("horror", 4, "We had him but the little rat crawled away. The hunt begins.", "He beat us. We must recover. We must escape.")
	success_path()
	addtext("success_path 1")
	failure_path()
	addtext("failure path 1")
	end_check()
	addbranch("Give up. This isn't their fault, it's yours. You've earned this. Don't resist.", false)
	addtext("You step away from the door and wait for them to enter. They open the door, tell you to pack your things and then wait.")
	end_tree()
	addtext("After packing for a few minutes, all you hear is your heartbeat. It's beating at a pace you've not felt for years.")
	addtext("... yet, you finish getting your things. You look at your empty cell one last time.")
	addtext("You will not miss this place, no matter what happens.")
	addtext("With all of your things in order, you exit your cell and walk with the guardsmen to the checking station. There you are given the letter that the guardsmen spoke about, your clothes from before inprisonment and 3$ and 26 cents.")
	addtext("They walk you out towards the enterance of the prison, and for the first time in a very... very long time. You are on the outside, a free man yet again.")
	addtext("The guardsmen give a sallute. They bid you adieu and walk away.")
	
	Data.intro_file = unparsed_file
	pass

func story_corporate_file():
	unparsed_file.clear()
	
	addtext("You enter the corporate building with a careful step. You can feel an aura of careful planning and preperation.")
	addtext("The Corporate Sector. Behold the glory of the mundane! The quiet air filled with whispers about documents and codes. I could stand here all day, if it wasn't a violation of health codes and safety regulations.", "Machine")
	addtext("We should do what we must and leave before he starts touching himself... or worse. Speaks again.", "Horror")
	addtext("You stand before the receptionist; who seems unaffected by your presence. It's an older woman with glasses and hair kept up in a bun.")
	addtext("She seems like the teacher-type of person to strike your hands with a ruler if you answer incorrectly. Be careful here...", "Horror")
	addtext("Without approaching her, she demands...")
	addtext("Yes, I am available. What do you need, sir.", "Receptionist.")
	addtext("This is your moment. Be straight to the case and state your business.")
	addtree("")
	addbranch("Uhm... I need to file this document. How would I go about doing that?")
	
	addbranch("Ahm, I am filing this document. [Roll For Machine: 6]")
	adddicecheck("Machine", 6)
	success_path()
	addtext("I need to process this f16 n12 Document with red ink. I believe in order to do so, I need assistance from a melodie?")
	addtext("She asks for the document and nods acceptantly while reading it. Yes, Yes... This is the correct documentation but the melodie is currently unavailable as she's on a different assignment.")
	addtext("Actually, this doesn't require a melodie unless there's been a loss of life under the proceedure. There is none marked, but for safety's sake I may as well ask. Has there been a loss of life since the last document was files?")
	
	addtree("Has there been a loss of life since the last document filing?")
	addbranch("Yes, a life or more has been lost.")
	addtext("Okey, I will note that on the document.")
	addbranch("No, no life has been lost.")
	addtext("That's a shame. Oh well, I will note that on the document.")
	end_tree()
	
	failure_path()
	addtext("I need to file this document... is... can you do it?")
	addtext("She stares at you. Her eyes yell for rest. She's tired... and you are not helping. She sighs, and asks for the document.")
	addtext("She skims it quickly and points out the first...and second... and third mistake the document has. You forgot to set if a loss of life was present, what code violation was commited, was there a breach?")
	addtext("These are severe mistakes to make, sir. Are you sure you are filing this document?")
	addtext("You mentally retreat and instinctually take a step back. May I have the document back?")
	addtext("She hands you the document, but before releasing it tells you. Don't waste my time, sir. She releases. You now have the document... and a new found shame.")
	end_check()
	
	addbranch("Oh, ah. I am fueling this doctor's concept. Would a black-inked press be suffice?")
	addtext("Excuse me? The woman looks at you with nothing but confusion and worry. Why did you say that? Was it a joke?")
	addtext("The silence in the room is made tenfold. You quickly say something else.")
	addbranch("I...uh. I am here for a purpose, please ignore me. [in panic, walk towards the back?]")
	
	addbranch("Hu... a... I have what I require. Good bye. [Leave]")
	
	end_tree()
	Data.corporate_story = unparsed_file
	pass

## Adders

func startfile():
	unparsed_file.clear()
	var data = {
		"labels":{},
	}
	unparsed_file["data"] = data
	return data

func addblock(data):
	print("ADD BLOCK DATA: ", data)
	
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
	var list_num = unparsed_file.size()
	
	# Add to file
	var data = cog_text.new()
	data.speaker = speaker
	if speaker.length() > 0:
		data.speaker = speaker.to_upper()
	
	data.text = text
	# if in tree or branch.
	data.tree = current_tree.back() if current_tree.size() > 0 else null
	data.branch = current_branch.back() if current_branch.size() > 0 else null
	unparsed_file[list_num] = data
	return data

func addtree(text = ""):
	var list_num = unparsed_file.size()
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
	unparsed_file[list_num] = data
	return data

func addbranch(text = "", goto_tree = true, conditions = []):
	var list_num = unparsed_file.size()
	var previous_list = unparsed_file[list_num - 1]
	var tree = unparsed_file[current_tree[-1]] # Get tree from file
	# Branch Stuff
	## Get previous branch if branch exists. Used as an END point for previous branch. if branch is empty, aka -1, then dont set the end.
	var previous_branch = null if current_branch[-1] == -1 else unparsed_file[current_branch.back()] # get previous branch if not empty
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
	unparsed_file[list_num] = data
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
	var list_num = unparsed_file.size()
	var previous_list = unparsed_file[list_num - 1]
	var previous_branch = null if current_branch[-1] == -1 else unparsed_file[current_branch.back()]
	
	if previous_branch != null:
		previous_list.isBranchEnd = true
		previous_branch.end = list_num
		pass
	
	var tree = unparsed_file[current_tree.back()]
	tree.end = list_num
	
	# Add to file
	var data = cog_tree_end.new()
	data.text = "! Tree end !"
	data.tree = current_tree.back() if current_tree.size() > 0 else null
	data.branch = current_branch.back() if current_branch.size() > 0 else null
	data.isTreeEnd = true
	unparsed_file[list_num] = data
	
	current_branch.pop_back()
	current_tree.pop_back()
	return data

func changebg(source, fade = true, speed = 1):
	var list_num = unparsed_file.size()
	var data = cog_changebg.new()
	data.source = source
	data.fade_inout = fade
	data.speed = speed
	unparsed_file[list_num] = data
	return data

func setlabel(text: String):
	var list_num = unparsed_file.size()
	var data = cog_label.new()
	data.text = text
	unparsed_file["data"].labels[text] = list_num
	unparsed_file[list_num] = data
	return data

func addgoto(text: String):
	var list_num = unparsed_file.size()
	var data = cog_goto.new()
	data.text = text
	unparsed_file[list_num] = data
	return data

func addstatcheck(stat = "", dc = -1):
	var list_num = unparsed_file.size()
	var data = cog_statcheck.new()
	data.stat = stat
	data.dc = dc
	unparsed_file[list_num] = data
	current_check.append(list_num)
	return data

func adddicecheck(stat = "", dc = -1):
	var list_num = unparsed_file.size()
	var data = cog_dicecheck.new()
	data.stat = stat
	data.dc = dc
	unparsed_file[list_num] = data
	current_check.append(list_num)
	return data

func success_path():
	var list_num = unparsed_file.size()
	var data = cog_check_success.new()
	
	current_success.append(list_num)
	
	unparsed_file[list_num] = data
	return data

func failure_path():
	var list_num = unparsed_file.size()
	var data = cog_check_failure.new()
	
	current_failure.append(list_num)
	
	unparsed_file[list_num] = data
	return data

func end_check():
	var list_num = unparsed_file.size()
	
	var data = cog_check_end.new()
	unparsed_file[list_num] = data
	
	if current_check.size() == current_success.size(): # Set end of success if success exists
		unparsed_file[current_success.back()].end = list_num
		current_success.pop_back()
	if current_check.size() == current_failure.size(): # Set end of failure if failure exists
		unparsed_file[current_failure.back()].end = list_num 
		current_failure.pop_back()
	
	unparsed_file[current_check.back()].end = list_num # Set end of check branch
	current_check.pop_back()
	return data

func addpassivecheck(stat, dc, success_text = "", failure_text = ""):
	var list_num = unparsed_file.size()
	var data  = cog_statcheck_passive.new()
	data.stat = stat
	data.dc   = dc
	data.success_text = success_text
	data.failure_text = failure_text
	unparsed_file[list_num] = data
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
