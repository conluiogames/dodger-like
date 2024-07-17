extends Area2D

var plBullet := preload("res://assets/scenes/Bullet.tscn")

onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $Timer

export var speed: float = 100
export var fireDelay: float = 0.3
var vel := Vector2(0, 0)

func _process(delta):
	
	# Tiro
	if Input.is_action_pressed("shoot") and fireDelayTimer.is_stopped():
		fireDelayTimer.start(fireDelay)
		for child in firingPositions.get_children():
			var bullet := plBullet.instance()
			bullet.global_position = child.global_position
			get_tree().current_scene.add_child(bullet)
	
func _physics_process(delta):
	var dirVec := Vector2(0, 0)
	
	if Input.is_action_pressed("move_left"):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right"):
		dirVec.x = 1
	if Input.is_action_pressed("move_up"):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down"):
		dirVec.y = 1

	vel = dirVec.normalized() * speed
	position += vel * delta
	
	# Nave dentro da cena (bounds)
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)
