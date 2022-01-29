extends Camera2D
class_name ShakingCamera

onready var _screen_shake: ScreenShake = $ScreenShake


func trigger_small_shake() -> void:
	_screen_shake.start(.1, 8, 10, 2)


func trigger_medium_shake() -> void:
	_screen_shake.start(.1, 14, 20, 5)


func trigger_large_shake() -> void:
	_screen_shake.start(.1, 18, 30, 10)
