extends Node2D


var is_slapping: bool = false


onready var _visual: Node2D = $Visual
onready var _slap_timer: Timer = $SlapTimer
onready var _hit_box: Area2D = $Hitbox


func _process(delta):
	if is_slapping:
		return
	
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	position = get_viewport().get_mouse_position()
	

func _input(event):
	if not event.is_action_pressed("click"):
		return
	
	if is_slapping:
		return
	
	is_slapping = true
	
	_hit_box.set_collision_layer_bit(0, true)
	_hit_box.set_collision_mask_bit(0, true)
	
	_visual.modulate = Color.red
	
	_slap_timer.start()
	yield(_slap_timer, "timeout")
	
	_visual.modulate = Color.white
	
	_hit_box.set_collision_layer_bit(0, false)
	_hit_box.set_collision_mask_bit(0, false)
	
	is_slapping = false
