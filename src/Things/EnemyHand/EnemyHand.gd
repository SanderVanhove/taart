extends Node2D
class_name EnemyHand

var arm_skins = [
	preload("res://Things/EnemyHand/Cat_Arm.png"),
	preload("res://Things/EnemyHand/Fuzzy_Arm.png"),
	preload("res://Things/EnemyHand/Octopus_arm.png"),
	preload("res://Things/EnemyHand/Human_arm.png"),
	preload("res://Things/EnemyHand/Zombie_arm.png"),
	preload("res://Things/EnemyHand/kikker_arm.png"),
	preload("res://Things/EnemyHand/monster_arm.png")
]

signal got_hit
signal got_taart

const HALF_PI: float = PI/2
const GRAB_DIST: float = 100.0

export var moving_speed: float = 5.0

var taart
var retreat_speed: float =  moving_speed * 3
var is_retreating: bool = false
var is_slapped: bool = false

onready var _tween: Tween = $Tween
onready var _moving_part: Node2D = $MovingPart
onready var _area: Area2D = $MovingPart/Area2D
onready var _hand: Sprite = $MovingPart/Visual/Arm
onready var _hand2: Sprite = $MovingPart/Visual/Arm2
onready var _taartje: Sprite = $MovingPart/Visual/Taart4
onready var _face: HandFace = $MovingPart/Visual/HandFace

onready var _auw_sound: RandomStreamPlayer = $MovingPart/AuwAudio
onready var _yey_audio: RandomStreamPlayer = $MovingPart/YeyAudio


func _ready():
	var texture = arm_skins[randi() % len(arm_skins)]
	_hand.texture = texture
	_hand2.texture = texture


func _process(delta):
	rotate_to_taart()
	move()


func move():
	if is_slapped:
		return
	
	var vector_towards_taart = taart.taart.global_position - _moving_part.global_position
	
	if not is_slapped and not is_retreating and vector_towards_taart.length() < GRAB_DIST:
		is_retreating = true
		
		if not taart.is_invulnarable:
			_taartje.show()
			if position.x < 0:
				_taartje.scale.y *= -1
				
			_face.show_cake_face()
			if position.x < 0:
				_face.scale.y *= -1
			
			_yey_audio.play()
		
		retreat_wiggle(70)
		
		emit_signal("got_taart")
	
	if not is_retreating:
		_moving_part.position.y -= moving_speed
	else:
		_moving_part.position.y += retreat_speed


func retreat_wiggle(delta: float):
	_area.set_collision_layer_bit(0, false)
	_area.set_collision_mask_bit(0, false)
	
	delta *= 1 if randi() % 2 == 0 else -1
	_tween.interpolate_property(_moving_part, "position:x", 0, delta, .15, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	_tween.repeat = true
	_tween.interpolate_property(_moving_part, "position:x", delta, -delta, .3, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(_moving_part, "position:x", -delta, delta, .3, Tween.TRANS_SINE, Tween.EASE_IN, .3)
	_tween.start()


func rotate_to_taart():
	var vector_towards_taart = taart.taart.global_position - self.global_position
	rotation = atan2(vector_towards_taart.y, vector_towards_taart.x) + HALF_PI


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	if not area.is_in_group("player") or is_retreating:
		return
		
	_auw_sound.play()
	
	is_slapped = true
	is_retreating = true
	
	emit_signal("got_hit")
	
	_face.show_smack_face()
	if position.x < 0:
		_face.scale.y *= -1
	
	var wiggle_dist: float = 20
	var time: float = .1
	
	_tween.remove_all()
	_tween.repeat = false
	
	_tween.interpolate_property(_moving_part, "position:x", wiggle_dist, -wiggle_dist, time, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(_moving_part, "position:x", -wiggle_dist, wiggle_dist, time, Tween.TRANS_SINE, Tween.EASE_IN, time)
	_tween.interpolate_property(_moving_part, "position:x", wiggle_dist, -wiggle_dist, time, Tween.TRANS_SINE, Tween.EASE_OUT, time * 2)
	_tween.interpolate_property(_moving_part, "position:x", -wiggle_dist, wiggle_dist, time, Tween.TRANS_SINE, Tween.EASE_IN, time * 3)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	retreat_wiggle(35)
	
	
	is_slapped = false


func go_away():
	_tween.remove_all()
	_tween.repeat = false
	
	retreat_wiggle(30)
	is_retreating = true
