extends Node2D


func _ready():
	var children = get_children()
	
	for i in range(len(children)):
		var letter: Letter = children[i] as Letter
		
		letter.delay = -i
		letter.start()
