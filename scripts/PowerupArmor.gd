extends PowerUP

func _ready():
	connect("area_entered", self, "_on_area_entered")
	pass

func _on_area_entered(other):
	if other.is_in_group("ship"):
		other.life += 1
		audio_player.play("powerup")
		queue_free()
	pass
