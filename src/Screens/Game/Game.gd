extends Node2D

var EnemyHandScene: PackedScene = preload("res://Things/EnemyHand/EnemyHand.tscn")

const SPAWN_MARGIN: float = 200.0
onready var SCREEN_SIZE: Vector2 = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height")) # get_viewport().size
const GAME_DURATION: float = 45.0

var time: float = 0
var lives: int = 4
var has_begun: bool = false
var ended: bool = false

onready var _taart: Taart = $Taart
onready var _enemy_hands: Node2D = $EnemyHands
onready var _shaking_camera: ShakingCamera = $Camera2D
onready var _stolen_taart_timer: Timer = $StolenTaartTimer
onready var _invulnarable_timer: Timer = $InvulnarableTimer
onready var _new_enemy_timer: Timer = $NewEnemyTimer
onready var _tween: Tween = $Tween
onready var _tutorial: Node2D = $Tutorial
onready var _tafel: Tafel = $Tafel
onready var _end_screen: Node2D = $EndScreen


func _ready():
	randomize()

	_tween.interpolate_property(self, "modulate:a", 0, 1, .5)
	_tween.start()

	_taart.position.y += 900

	_tafel.position.y += 1050


func _input(event):
	if not event.is_action_pressed("click") or has_begun:
		return

	has_begun = true

	_tween.interpolate_property(_tutorial, "modulate:a", 1, 0, .4, Tween.TRANS_SINE, Tween.EASE_IN)
	_tween.interpolate_property(_taart, "position:y", _taart.position.y, _taart.position.y - 900, .8, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()

	yield(_tween, "tween_all_completed")

	_tutorial.queue_free()

	_new_enemy_timer.start()


func end_sequence():
	_tween.remove_all()
	_tween.repeat = false

	_tween.interpolate_property(_tafel, "position:y", _tafel.position.y, _tafel.position.y - 1050, 1.5, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()

	yield(_tween, "tween_all_completed")

	_taart.stop_walking(lives)

	yield(get_tree().create_timer(1), "timeout")
	_tafel.trigger(lives)

	yield(get_tree().create_timer(4.5), "timeout")
	_end_screen.show()
	_tween.interpolate_property(_end_screen, "modulate:a", 0, 1, .5, Tween.TRANS_SINE, Tween.EASE_OUT)
	_tween.start()
	_end_screen.trigger()


func _process(delta):
	if not has_begun or ended:
		return

	time += delta
	_taart.update_time(clamp(1.0 - time / GAME_DURATION, 0, 1))

	if GAME_DURATION - time <= 0:
		ended = true

		_new_enemy_timer.stop()

		for hand in _enemy_hands.get_children():
			hand.go_away()

		end_sequence()


func _on_NewEnemyTimer_timeout():
	var new_enemy: EnemyHand = EnemyHandScene.instance()
	new_enemy.taart = _taart
	new_enemy.moving_speed = 5 + randf() * 2

	if randi() % 2 == 0:
		new_enemy.position.x = SCREEN_SIZE.x + SPAWN_MARGIN
	else:
		new_enemy.position.x = -SPAWN_MARGIN

	new_enemy.position.y = fmod(randi(), (SCREEN_SIZE.y + SPAWN_MARGIN)) - SPAWN_MARGIN / 2

	new_enemy.connect("got_hit", _shaking_camera, "trigger_medium_shake")
	new_enemy.connect("got_taart", self, "taart_stolen")

	_enemy_hands.add_child(new_enemy)

	_new_enemy_timer.wait_time = clamp(_new_enemy_timer.wait_time * .85, .55, 5)


func _on_Hand_slap():
	_shaking_camera.trigger_small_shake()


func taart_stolen():
	_shaking_camera.trigger_large_shake()
	get_tree().paused = true


	if not _taart.is_invulnarable:
		lives -= 1
		_taart.set_num_pieces(lives)

	_taart.is_invulnarable = true

	_stolen_taart_timer.start()
	yield(_stolen_taart_timer, "timeout")

	get_tree().paused = false

	if lives == 0:
		ended = true

		_new_enemy_timer.stop()

		for hand in _enemy_hands.get_children():
			hand.go_away()

		end_sequence()

	_invulnarable_timer.start()
	yield(_invulnarable_timer, "timeout")

	_taart.is_invulnarable = false

