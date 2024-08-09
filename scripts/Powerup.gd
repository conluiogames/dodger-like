extends Area2D

class_name PowerUP

var velocity = Vector2(0, 100)

func _ready():
	pass

func _process(delta):
	translate(velocity * delta)
	
	if position.y >= Utils.view_size.y+7:
		queue_free()
	pass
