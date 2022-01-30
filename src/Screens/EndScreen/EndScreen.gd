extends Node2D


onready var _thanks_audio: AudioStreamPlayer = $ThanksAudio


func trigger():
	_thanks_audio.play()


func _on_TextureButton_pressed():
	get_tree().change_scene("res://Screens/Game/Game.tscn")
