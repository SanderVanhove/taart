extends Node2D

signal slap


var is_slapping: bool = false


onready var _visual: Node2D = $Visual
onready var _slap_timer: Timer = $SlapTimer
onready var _hit_box: Area2D = $Visual/Hand/Hitbox
onready var _hand: Node2D = $Visual/Hand
onready var _slap_lines1: Node2D = $Visual/Hand/SlapLines1
onready var _slap_lines2: Node2D = $Visual/Hand/SlapLines2


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	if is_slapping:
		return
	
	var mouse_pos: Vector2 = get_viewport().get_mouse_position()
	if mouse_pos.x > position.x + 40:
		_hand.rotation = lerp(_hand.rotation, PI/4, .2)
	elif mouse_pos.x < position.x - 40:
		_hand.rotation = lerp(_hand.rotation, -PI/4, .2)
	else:
		_hand.rotation = lerp(_hand.rotation, 0, .2)
	
	if abs((position - mouse_pos).x) <= 10:
		position = mouse_pos
	else:
		position = lerp(position, mouse_pos, .4)
	

func _input(event):
	if not event.is_action_pressed("click"):
		return
	
	if is_slapping:
		return
		
	emit_signal("slap")
	
	is_slapping = true
	
	_visual.modulate = Color.red
	
	enable_hitbox()
	
	_slap_timer.start()
	yield(_slap_timer, "timeout")
	
	_visual.modulate = Color.white
	
	is_slapping = false


func enable_hitbox():
	_hit_box.set_collision_layer_bit(0, true)
	_hit_box.set_collision_mask_bit(0, true)
	
	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
	
	_hit_box.set_collision_layer_bit(0, false)
	_hit_box.set_collision_mask_bit(0, false)


func _on_Hitbox_area_entered(area):
	if _slap_lines1.visible or _slap_lines2.visible:
		return
	
	_slap_lines1.visible = true
	
	for i in range(3):
		_slap_timer.start()
		yield(_slap_timer, "timeout")
		
		_slap_lines1.visible = not _slap_lines1.visible
		_slap_lines2.visible = not _slap_lines2.visible
	
	_slap_lines1.visible = false
	_slap_lines2.visible = false
