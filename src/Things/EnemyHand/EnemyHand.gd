extends Node2D
class_name EnemyHand

signal got_hit
signal got_taart

const HALF_PI: float = PI/2
const GRAB_DIST: float = 100.0

export var moving_speed: float = 5.0

var taart: Node2D
var retreat_speed: float =  moving_speed * 3
var is_retreating: bool = false
var is_slapped: bool = false

onready var _tween: Tween = $Tween
onready var _moving_part: Node2D = $MovingPart
onready var _area: Area2D = $MovingPart/Area2D


func _process(delta):
	rotate_to_taart()
	move()


func move():
	if is_slapped:
		return
	
	var vector_towards_taart = taart.global_position - _moving_part.global_position
	
	if not is_slapped and not is_retreating and vector_towards_taart.length() < GRAB_DIST:
		is_retreating = true
		
		retreat_wiggle(50)
		
		emit_signal("got_taart")
	
	if not is_retreating:
		_moving_part.position.y -= moving_speed
	else:
		_moving_part.position.y += retreat_speed


func retreat_wiggle(delta: float):
	delta *= 1 if randi() % 2 == 0 else -1
	_tween.interpolate_property(_moving_part, "position:x", 0, delta, .15, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	_tween.repeat = true
	_tween.interpolate_property(_moving_part, "position:x", delta, -delta, .3, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.interpolate_property(_moving_part, "position:x", -delta, delta, .3, Tween.TRANS_SINE, Tween.EASE_IN, .3)
	_tween.start()


func rotate_to_taart():
	var vector_towards_taart = taart.global_position - self.global_position
	rotation = atan2(vector_towards_taart.y, vector_towards_taart.x) + HALF_PI


func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Area2D_area_entered(area):
	if not area.is_in_group("player") or is_retreating:
		return
	
	is_slapped = true
	is_retreating = true
	
	emit_signal("got_hit")
	
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
	
	retreat_wiggle(30)
	
	
	is_slapped = false
