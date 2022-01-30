extends Node2D
class_name TaartFace


onready var _visual: Node2D = $Visual
onready var _tween: Tween = $Tween


func set_face(index: int):
	for face in _visual.get_children():
		face.hide()
	
	_visual.get_child(index).show()


func set_shake(level: int):
	_tween.remove_all()
	
	var time = .5 / level
	var dist = 4 * level
	
	_tween.interpolate_property(_visual, "position:x", dist, -dist, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_tween.interpolate_property(_visual, "position:x", -dist, dist, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT, time)
	_tween.start()
