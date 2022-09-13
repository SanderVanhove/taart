extends Node2D

var GameScene: PackedScene
var loader: ResourceInteractiveLoader


onready var _button_audio: AudioStreamPlayer = $ButtonAudio
onready var _tween: Tween = $Tween
onready var _taart_audio: RandomStreamPlayer = $TaartAudio


func _ready():
	loader = ResourceLoader.load_interactive("res://Screens/Game/Game.tscn")

	modulate.a = 0
	_tween.interpolate_property(self, "modulate:a", 0, 1, .7)
	_tween.start()


func _process(delta: float) -> void:
	if loader == null:
		set_process(false)
		return

	var err = loader.poll()

	if err == ERR_FILE_EOF:
		GameScene = loader.get_resource()
		loader = null

func _on_Button_pressed():
	get_tree().change_scene("res://Screens/Game/Game.tscn")


func _on_TextureButton_pressed():
	_tween.interpolate_property(self, "modulate:a", 1, 0, .3)
	_tween.start()

	_button_audio.play()
	yield(_button_audio, "finished")
	get_tree().change_scene_to(GameScene)


func _on_TaartTimer_timeout():
	_taart_audio.play()
