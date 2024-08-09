extends "res://scripts/Laser.gd"

func _ready():
	connect("area_entered", self, "_on_area_entered")
	audio_player.play("laser_enemy")
	pass

func _on_area_entered(other):
	if other.is_in_group("ship"):
		other.damage(1)
		create_flare()
		Utils.remote_call("camera", "shake", 3, 0.13)
		queue_free()
	pass
