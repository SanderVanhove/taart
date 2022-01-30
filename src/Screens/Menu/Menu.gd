extends Node2D


onready var _button_audio: AudioStreamPlayer = $ButtonAudio
onready var _tween: Tween = $Tween


func _on_Button_pressed():
	get_tree().change_scene("res://Screens/Game/Game.tscn")


func _on_TextureButton_pressed():
	_tween.interpolate_property(self, "modulate:a", 1, 0, .3)
	_tween.start()
	
	_button_audio.play()
	yield(_button_audio, "finished")
	get_tree().change_scene("res://Screens/Game/Game.tscn")
