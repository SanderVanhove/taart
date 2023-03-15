extends Node2D

signal slap


var is_slapping: bool = false


onready var _visual: Node2D = $Visual
onready var _slap_timer: Timer = $SlapTimer
onready var _hit_box: Area2D = $Visual/Hand/Hitbox
onready var _hand: Node2D = $Visual/Hand
onready var _normal_hand: Node2D = $Visual/Hand/NormalHand
onready var _slap_hand: Node2D = $Visual/Hand/SlapHand
onready var _slap_lines1: Node2D = $Visual/Hand/SlapLines1
onready var _slap_lines2: Node2D = $Visual/Hand/SlapLines2

onready var _slap_audio: RandomStreamPlayer = $SlapAudio

var _target_position: Vector2 = Vector2(1920/2.0, 1080/2.0)
var _use_gamepad: bool = Input.get_connected_joypads().size() > 0
var _hand_speed: float = 0


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)


func _process(delta):
	if is_slapping:
		return

	if _use_gamepad:
		var joy_dir: Vector2 = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
		if joy_dir.length_squared() != 0:
			_hand_speed = lerp(_hand_speed, 1900, .2)
		else:
			_hand_speed = lerp(_hand_speed, 0, .5)
			
		_target_position += joy_dir * _hand_speed * delta
	else:
		_target_position = get_viewport().get_mouse_position()

	if _target_position.x > position.x + 40:
		_hand.rotation = lerp(_hand.rotation, PI/4, .2)
	elif _target_position.x < position.x - 40:
		_hand.rotation = lerp(_hand.rotation, -PI/4, .2)
	else:
		_hand.rotation = lerp(_hand.rotation, 0, .2)

	if abs((position - _target_position).x) <= 10:
		position = _target_position
	else:
		position = lerp(position, _target_position, .4)


func _input(event):
	if not event.is_action_pressed("click"):
		return

	if is_slapping:
		return

	_slap_audio.play()

	emit_signal("slap")

	is_slapping = true

	_normal_hand.hide()
	_slap_hand.show()

	enable_hitbox()

	_slap_timer.start()
	yield(_slap_timer, "timeout")

	_normal_hand.show()
	_slap_hand.hide()

	is_slapping = false


func enable_hitbox():
	_hit_box.set_collision_layer_bit(0, true)
	_hit_box.set_collision_mask_bit(0, true)

	yield(get_tree(), "idle_frame")
	yield(get_tree(), "idle_frame")
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
