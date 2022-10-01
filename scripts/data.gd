extends Node

const COG_TYPE_TEXT 	= "cog_type_text"
const COG_TYPE_TREE 	= "cog_type_tree"
const COG_TYPE_TREE_END = "cog_type_tree_end"
const COG_TYPE_BRANCH 	= "cog_type_branch"
const COG_TYPE_GOTO 	= "cog_type_goto"
const COG_TYPE_LABEL 	= "cog_type_label"
const COG_TYPE_CHANGEBG = "cog_type_background_change"
const COG_TYPE_CHANGE_PATH = "cog_type_change_path"

const COG_TYPE_DICECHECK     = "cog_type_dicecheck"
const COG_TYPE_STATCHECK     = "cog_type_statcheck"
const COG_TYPE_CHECK_SUCCESS = "cog_type_check_success"
const COG_TYPE_CHECK_FAILURE = "cog_type_check_failure"
const COG_TYPE_CHECK_END     = "cog_type_check_end"

const COG_TYPE_CHECK_PASSIVE = "cog_type_check_passive"

var intro_file
var corporate_story

var testing_current_line = null

const stat = {
	reason = "REASON",
	wisdom = "WISDOM",
	meche  = "MECHE", # Machine, Mechanist, Meche (Means nothing, sounds cool), Belief, Trust.
	abyss  = "VOID"   # Other names that might fit are: Grime, Grunge, Grease, Tainted, Pestilence, Pollution.
}

# Good names...
# Marwin 

# The 4 skills are catagorised as 
# Reasoning, Knowledge, Religiousness combined with Engineering and 
# finally the (grotesc and vile) combined with paperwork.

## EDITOR DATA ##

var ed_characters = []
var ed_paths = []




































# 
