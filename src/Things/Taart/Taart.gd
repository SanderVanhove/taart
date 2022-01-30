extends Node2D
class_name Taart


const SWAY_DIST: Vector2 = Vector2(100, 70)
const SLIDE_DIST: Vector2 = Vector2(20, -15)
const WALK_TIME: float = 1.3
const SLIDE_TIME: float = .4
const JUMP_TIME: float = .1

var slide_delay: float = WALK_TIME - SLIDE_TIME
var jump_delay: float = WALK_TIME - JUMP_TIME * 2
var is_invulnarable: bool = false


onready var taart: Node2D = $CarryingHand/Taart
onready var _carrying_hand: Node2D = $CarryingHand
onready var _walking_tween: Tween = $WalkingTween
onready var _taart_tween: Tween = $TaartTween
onready var _candles: Node2D = $CarryingHand/Taart/Candles
onready var _face: HandFace = $CarryingHand/Taart/TaartFace
onready var _tear_audio: RandomStreamPlayer = $TearAudio

onready var _taarts: Array = [
	$CarryingHand/Taart/Taart1,
	$CarryingHand/Taart/Taart2,
	$CarryingHand/Taart/Taart3,
	$CarryingHand/Taart/Taart4,
]
onready var _individual_candles: Array = [
	$CarryingHand/Taart/Candles/Candle,
	$CarryingHand/Taart/Candles/Candle2,
	$CarryingHand/Taart/Candles/Candle3,
	$CarryingHand/Taart/Candles/Candle4,
]


func _ready():
	randomize()
	
	start_sliding_taart()
	start_walking()
	
	_face.show_cake_face()
	

func start_sliding_taart():
	taart.position.x = SLIDE_DIST.x
	
	_taart_tween.interpolate_property(taart, "position:x", SLIDE_DIST.x, -SLIDE_DIST.x, SLIDE_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, slide_delay)
	_taart_tween.interpolate_property(taart, "position:x", -SLIDE_DIST.x, SLIDE_DIST.x, SLIDE_TIME, Tween.TRANS_QUAD, Tween.EASE_IN_OUT, WALK_TIME + slide_delay)
	
	_taart_tween.interpolate_property(taart, "position:y", 0, SLIDE_DIST.y, JUMP_TIME, Tween.TRANS_SINE, Tween.EASE_OUT, jump_delay)
	_taart_tween.interpolate_property(taart, "position:y", SLIDE_DIST.y, 0, JUMP_TIME, Tween.TRANS_SINE, Tween.EASE_IN, jump_delay + JUMP_TIME)
	
	_taart_tween.interpolate_property(taart, "position:y", 0, SLIDE_DIST.y, JUMP_TIME, Tween.TRANS_SINE, Tween.EASE_OUT, WALK_TIME + jump_delay)
	_taart_tween.interpolate_property(taart, "position:y", SLIDE_DIST.y, 0, JUMP_TIME, Tween.TRANS_SINE, Tween.EASE_IN, WALK_TIME + jump_delay + JUMP_TIME)
	
	_taart_tween.start()


func start_walking():
	_walking_tween.repeat = true
	_walking_tween.interpolate_property(_carrying_hand, "position:x", SWAY_DIST.x, -SWAY_DIST.x, WALK_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_walking_tween.interpolate_property(_carrying_hand, "position:x", -SWAY_DIST.x, SWAY_DIST.x, WALK_TIME, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME)
	
	_walking_tween.interpolate_property(_carrying_hand, "position:y", 0, SWAY_DIST.y, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", SWAY_DIST.y, 0, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME/2)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", 0, SWAY_DIST.y, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", SWAY_DIST.y, 0, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME * 1.5)
	_walking_tween.start()


func update_time(percentage: float):
	for candle in _candles.get_children():
		candle.percentage = percentage


func set_num_pieces(num_pieces: int):
	if num_pieces < 0:
		_face.hide()
		return
	
	_tear_audio.play()
	
	_face.show_smack_face()
	
	_taarts[num_pieces].hide()
	_individual_candles[num_pieces].hide()
	
	if num_pieces == 1:
		_face.position.x += 90
	
	_face.set_shake(4 - num_pieces)
	
	if num_pieces > 0:
		_taarts[num_pieces - 1].show()
	else:
		_face.hide()


func stop_walking():
	_walking_tween.remove_all()
	_taart_tween.remove_all()
	
	_walking_tween.interpolate_property(_carrying_hand, "position:y", 0, 20, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", 20, 0, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME/2)
	_walking_tween.start()
