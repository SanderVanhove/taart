extends Node2D

var EnemyHandScene: PackedScene = preload("res://Things/EnemyHand/EnemyHand.tscn")

const SPAWN_MARGIN: float = 200.0
onready var SCREEN_SIZE: Vector2 = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height")) # get_viewport().size
const GAME_DURATION: float = 10.0

var time: float = 0

onready var _taart: Node2D = $Taart
onready var _enemy_hands: Node2D = $EnemyHands
onready var _shaking_camera: ShakingCamera = $Camera2D
onready var _stolen_taart_timer: Timer = $StolenTaartTimer


func _ready():
	randomize()


func _process(delta):
	time += delta
	_taart.update_time(clamp(1.0 - time / GAME_DURATION, 0, 1))


func _on_NewEnemyTimer_timeout():
	var new_enemy: EnemyHand = EnemyHandScene.instance()
	new_enemy.taart = _taart.taart
	new_enemy.moving_speed = 5 + randf() * 2
	
	if randi() % 2 == 0:
		new_enemy.position.x = SCREEN_SIZE.x + SPAWN_MARGIN
	else:
		new_enemy.position.x = -SPAWN_MARGIN
	
	new_enemy.position.y = fmod(randi(), (SCREEN_SIZE.y + SPAWN_MARGIN)) - SPAWN_MARGIN / 2
	
	new_enemy.connect("got_hit", _shaking_camera, "trigger_medium_shake")
	new_enemy.connect("got_taart", self, "taart_stolen")
		
	_enemy_hands.add_child(new_enemy)


func _on_Hand_slap():
	_shaking_camera.trigger_small_shake()


func taart_stolen():
	_shaking_camera.trigger_large_shake()
	get_tree().paused = true
	
	_stolen_taart_timer.start()
	yield(_stolen_taart_timer, "timeout")
	
	get_tree().paused = false
	
