extends Node2D

export var speed: float = 500
var velocity = Vector2()
var audio

func _ready():
	audio = $AudioStreamPlayer2D

func _physics_process(delta):
	position += velocity * delta

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Bullet_area_entered(area):
	if area.is_in_group("damageable"):
		area.damage(1)
		queue_free()

func _on_AudioStreamPlayer2D_finished():
	audio.queue_free()
