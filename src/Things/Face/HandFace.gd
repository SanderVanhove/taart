extends Node2D
class_name HandFace


onready var _smack: Node2D = $Visual/Smack
onready var _cake: Node2D = $Visual/Cake
onready var _visual: Node2D = $Visual
onready var _tween: Tween = $Tween


func show_smack_face():
	for face in _cake.get_children():
		face.hide()
	for face in _smack.get_children():
		face.hide()
		
	_smack.get_child(randi() % _smack.get_child_count()).show()


func show_cake_face():
	_cake.get_child(randi() % _cake.get_child_count()).show()


func set_shake(level: int):
	_tween.remove_all()
	
	var time = .5 / level
	var dist = 4 * level
	
	_tween.interpolate_property(_visual, "position:x", dist, -dist, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_tween.interpolate_property(_visual, "position:x", -dist, dist, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT, time)
	_tween.start()
