extends Node2D


const SWAY_DIST: Vector2 = Vector2(100, 30)
const SLIDE_DIST: Vector2 = Vector2(10, -10)
const WALK_TIME: float = 1.3
const SLIDE_TIME: float = .4
const JUMP_TIME: float = .1

var slide_delay: float = WALK_TIME - SLIDE_TIME
var jump_delay: float = WALK_TIME - JUMP_TIME * 2


onready var taart: Node2D = $CarryingHand/Taart
onready var _carrying_hand: Node2D = $CarryingHand
onready var _walking_tween: Tween = $WalkingTween
onready var _taart_tween: Tween = $TaartTween
onready var _candles: Node2D = $CarryingHand/Taart/Candles


func _ready():
	start_sliding_taart()
	start_walking()
	

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
	
	_walking_tween.interpolate_property(_carrying_hand, "position:y", 0, SWAY_DIST.x, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", SWAY_DIST.x, 0, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME/2)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", 0, SWAY_DIST.x, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME)
	_walking_tween.interpolate_property(_carrying_hand, "position:y", SWAY_DIST.x, 0, WALK_TIME/2, Tween.TRANS_SINE, Tween.EASE_IN_OUT, WALK_TIME * 1.5)
	_walking_tween.start()


func update_time(percentage: float):
	for candle in _candles.get_children():
		candle.percentage = percentage
