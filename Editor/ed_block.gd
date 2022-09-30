extends Control

onready var movable_node = $Movable
onready var zindex = $Movable/ZIndex

var mouse_inside = false
var mouse_additive = Vector2.ZERO

var isHeld = false
var isMoving = false

var hasSnapped = false

func _ready():
	pass

func _process(delta):
	isHeld = false
	isMoving = false
	
	# State: player holding the cog
	if mouse_inside and Input.is_mouse_button_pressed(1):
		isHeld = true
	# else: isHeld = false
	
	# State: player releases cog, it floats towards it's end position
	if not isHeld:
		is_floating(delta)
	
	if isHeld:
		is_grabbed(delta)
	
	# Snap to location if you are near enough.
	snap_on_distance(20)
	
	# -- Triggers -- #
	
	# on snap to location
	if not should_move() and not hasSnapped:
		on_snap_to_location()
	
	$Movable/ZIndex/Base/Label.text = str(zindex.z_index)

func should_move():
	var should_it = false
	if movable_node.rect_position != rect_position:
		should_it = true
	return should_it

func snap_on_distance(dis):
	print("isHeld: ", str(isHeld), " : ", "isMoving: ", str(isMoving))
	if not isHeld and isMoving:
		print("move pos: ", str(movable_node.rect_position.y), " : ", "rect: ", rect_position.y)
		if movable_node.rect_position.y > rect_position.y - dis and movable_node.rect_position.y < rect_position.y + dis:
			movable_node.rect_position.y = rect_position.y
		if movable_node.rect_position.x > rect_position.x - dis and movable_node.rect_position.x < rect_position.x + dis:
			movable_node.rect_position.x = rect_position.x
		movable_node.rect_position.x = rect_position.x
	pass

func is_grabbed(delta):
	isMoving = true
	mouse_additive = movable_node.get_global_mouse_position() - (rect_size/2)
	movable_node.rect_global_position.y = mouse_additive.y 
	zindex.z_index = 10
	hasSnapped = false
	pass

func is_floating(delta):
	isMoving = true
	movable_node.rect_global_position = movable_node.rect_global_position.move_toward(rect_global_position, movable_node.rect_global_position.distance_to(rect_global_position) * delta * 3)
	zindex.z_index = 9
	hasSnapped = false
	pass

func on_snap_to_location():
	zindex.z_index = 0
	hasSnapped = true
	isMoving = false
	pass

func _on_PanelContainer_mouse_entered():
	mouse_inside = true
	pass

func _on_PanelContainer_mouse_exited():
#	set_all_nodes()
	mouse_inside = false
	pass

func _on_Cross_pressed():
	queue_free()
	pass 
