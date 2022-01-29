extends Node2D
class_name Candle


export var percentage: float = 1.0 setget set_percentage


onready var _base: Sprite = $Visual/Base
onready var _wax: Sprite = $Visual/MoltenWax

onready var og_wax_hight: float = _wax.position.y


func set_percentage(new_percentage: float):
	percentage = new_percentage
	
	_base.material.set_shader_param("percentage", percentage)
	_wax.position.y = og_wax_hight * percentage
