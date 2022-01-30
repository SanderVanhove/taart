extends Node2D


onready var _button_audio: AudioStreamPlayer = $ButtonAudio
onready var _tween: Tween = $Tween
onready var _taart_audio: RandomStreamPlayer = $TaartAudio


func _ready():
	modulate.a = 0
	_tween.interpolate_property(self, "modulate:a", 0, 1, .7)
	_tween.start()


func _on_Button_pressed():
	get_tree().change_scene("res://Screens/Game/Game.tscn")


func _on_TextureButton_pressed():
	_tween.interpolate_property(self, "modulate:a", 1, 0, .3)
	_tween.start()
	
	_button_audio.play()
	yield(_button_audio, "finished")
	get_tree().change_scene("res://Screens/Game/Game.tscn")


func _on_TaartTimer_timeout():
	_taart_audio.play()
