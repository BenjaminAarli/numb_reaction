extends Control

onready var movable_node = $Movable
onready var addons = $Movable/Addons

var mouse_inside = false
var mouse_additive = Vector2.ZERO

var add_to_right = 0
var full_size_x = 0

var type = "BLANK"

var data_characters = []
var data_paths 		= []

var state = null
var states = {
	isHeld 	   = "isHeld",
	isFloating = "isFloating",
	isStanding = "isStanding"
}

# Signals 

signal onRelease(_self)
signal onGrab(_self)
signal onSnap(_self)

func _ready():
	full_size_x = rect_size.x
	pass

var signal_emittable_onRelease = false
var signal_emittable_onGrab = false

func update_data(data):
	print("BLANK UPDATE DATA: ", data)
	pass

func get_data():
	var data = {}
	
	data["type"] = type
	
	for c in addons.get_children():
		print(c.get_class())
		match c.get_class():
			"TextEdit":
				data[str(c.name)] = c.text
		pass
	
	return data

func set_data(data):
	print(data)
	pass

func _process(delta):
	
	rect_position.x = add_to_right
	rect_size.x = full_size_x - add_to_right
	
	# State: player holding the cog
	if mouse_inside and Input.is_mouse_button_pressed(1):
		state = states.isHeld
	
	if not Input.is_mouse_button_pressed(1) and state == states.isHeld:
		state = states.isFloating
	
	if not should_move() and state != states.isHeld:
		state = states.isStanding
	
	check_states(delta)
	
	check_signal_onRelease()
	check_signal_onGrab()
	
	pass

func check_states(delta):
	match state: 
		states.isHeld:
			is_grabbed(delta)
			show_on_top = true
		states.isFloating:
			snap_on_distance(8, movable_node)
			is_floating(delta)
			show_on_top = true
		states.isStanding:
			show_on_top = false
			pass
	pass

func get_mid_pos():
	var pos = rect_position.y
	var half = rect_size.y / 2
	
	var global_pos = movable_node.rect_position.y
	
	return (pos + half) + global_pos

func get_moved_pos():
	return movable_node.rect_position

func get_global_moved_pos():
	return movable_node.rect_position

func set_moved_pos(pos: int):
	movable_node.rect_position.y = pos
	pass

func check_signal_onRelease():
	if state == states.isHeld:
		signal_emittable_onRelease = true
	
	if state == states.isFloating and signal_emittable_onRelease:
		emit_signal("onRelease", self)
		signal_emittable_onRelease = false
	
	if state == states.isStanding and signal_emittable_onRelease:
		emit_signal("onRelease", self)
		signal_emittable_onRelease = false
	pass

func check_signal_onGrab():
	if state == states.isHeld and not signal_emittable_onGrab:
		emit_signal("onGrab", self)
		signal_emittable_onGrab = true
	
	if state == states.isFloating or state == states.isStanding:
		signal_emittable_onGrab = false
	
	pass

func should_move():
	var should_it = true
	if int(movable_node.rect_position.y) == 0:
		should_it = false
	return should_it

func snap_on_distance(dis, move_node):
	if grab_pos != null:
		grab_pos = null
	var snap_position = 0
	var moving_position = move_node.rect_position.y
	if abs(moving_position) < abs(snap_position) + dis:
		move_node.rect_position.y = snap_position
	pass

var grab_pos = null
func is_grabbed(_delta):
	if grab_pos == null:
		grab_pos = movable_node.get_local_mouse_position()
	
	mouse_additive = get_global_mouse_position() - grab_pos
	
	movable_node.rect_global_position.y = mouse_additive.y
	pass

func is_floating(delta):
	if grab_pos != null:
		grab_pos = null
	
	var dir = movable_node.rect_position.direction_to(Vector2.ZERO)
	var dis = movable_node.rect_position.distance_to(Vector2.ZERO)
	var speed = (delta * dis) * 3
	movable_node.rect_position += dir * speed
	pass


# Basic Button and event handling. 

func _on_PanelContainer_mouse_entered():
	mouse_inside = true
	pass

func _on_PanelContainer_mouse_exited():
	mouse_inside = false
	pass

func _on_Cross_pressed():
	queue_free()
	pass 

func _on_cogBlank_onGrab():
	pass # Replace with function body.
