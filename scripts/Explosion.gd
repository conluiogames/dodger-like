extends Sprite

func _ready():
	randomize()
	rotation_degrees = rand_range(0, 360)
	get_parent().get_node("Camera2D").shake(5, 0.13)
	audio_player.play("explosion")
	pass
