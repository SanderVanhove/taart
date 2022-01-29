extends Node2D


onready var _taart: Node2D = $Taart
onready var _enemy_hands: Node2D = $EnemyHands


func _ready():
	for child in _enemy_hands.get_children():
		child.taart = _taart
