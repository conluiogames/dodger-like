extends Area2D

class_name Player

onready var gameplay := $".."
var plBullet := preload("res://prefabs/Bullet.tscn")

onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $Timer

export var speed: float = 100
export var fireDelay: float = 0.3
export var life: int = 3
var vel := Vector2(0, 0)

func _ready():
	print(gameplay)
	pass


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
	
	if Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D):
		dirVec.x = 1
	if Input.is_action_pressed("move_up") or Input.is_key_pressed(KEY_W):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down") or Input.is_key_pressed(KEY_S):
		dirVec.y = 1

	vel = dirVec.normalized() * speed
	position += vel * delta
	
	# Nave dentro da cena (bounds)
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)

func damage(amount: int):
	life -= amount
	print("Player Life = %s" % life)
	
	if life <= 0:
		print("PLAYER DIED")
		gameplay.set_state("GAMEOVER")
		queue_free()
