extends Node2D


onready var _text: Control = $RichTextLabel
onready var _tween: Tween = $Tween


# Called when the node enters the scene tree for the first time.
func _ready():
	_text.modulate.a = 0
	_tween.interpolate_property(_text, "modulate:a", 0, 1, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	_tween.start()


func _on_VanishTimer_timeout():
	_tween.interpolate_property(_text, "modulate:a", 1, 0, 1, Tween.TRANS_SINE, Tween.EASE_IN)
	_tween.start()
	
	yield(_tween, "tween_all_completed")
	
	get_tree().change_scene("res://Screens/Menu/Menu.tscn")
