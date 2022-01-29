extends Sprite
class_name Letter

const dist: float = -50.0
const time: float = 2.0
var delay: float = 1.0


onready var _tween: Tween = $Tween

func start():
	_tween.repeat = true
	
	_tween.interpolate_property(self, "position:y", 0, dist, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_tween.interpolate_property(self, "position:y", dist, 0, time, Tween.TRANS_SINE, Tween.EASE_IN_OUT, time)
	_tween.start()
	
	_tween.seek(delay)
