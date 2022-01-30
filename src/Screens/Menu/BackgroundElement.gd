extends Sprite
class_name WrapAround

const SPEED: float = 100.0

export(int, 0, 100) var margin: float = 100.0

onready var screen_size: Vector2 = Vector2(ProjectSettings.get("display/window/size/width"),ProjectSettings.get("display/window/size/height"))

var direction: Vector2
var rotation_dir: float


func _ready():
	randomize()
	direction = Vector2(randf(), randf()).normalized().rotated(randf() * PI * 2)
	rotation_dir = .002 if randi() % 2 == 0 else -.002


func _process(delta: float) -> void:
	rotation += rotation_dir
	position += direction * SPEED * delta

	position = Vector2(
		wrapf(position.x, 0 - margin, screen_size.x + margin),
		wrapf(position.y, 0 - margin, screen_size.y + margin)
	)
