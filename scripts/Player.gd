extends Area2D

class_name Player

signal isDead

onready var gameplay := $".."
var plBullet := preload("res://prefabs/Bullet.tscn")

onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $Timer

export var speed: float = 100
export var acceleration: float = 400
export var friction: float = 200
export var fireDelay: float = 0.3
export var life: int = 3
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
	#Comandos de Movimentação
	var dirVec := Vector2(0, 0)
	if Input.is_action_pressed("move_left") or Input.is_key_pressed(KEY_A):
		dirVec.x = -1
	elif Input.is_action_pressed("move_right") or Input.is_key_pressed(KEY_D):
		dirVec.x = 1
	if Input.is_action_pressed("move_up") or Input.is_key_pressed(KEY_W):
		dirVec.y = -1
	elif Input.is_action_pressed("move_down") or Input.is_key_pressed(KEY_S):
		dirVec.y = 1

	#efeito de atrito
	dirVec = dirVec.normalized()
	if dirVec != Vector2(0, 0):
		vel = vel.move_toward(dirVec * speed, acceleration * delta)
	else:
		vel = vel.move_toward(Vector2(0, 0), friction * delta)
	
	position += vel * delta
	
	# Nave dentro da cena (bounds)
	var viewRect := get_viewport_rect()
	position.x = clamp(position.x, 0, viewRect.size.x)
	position.y = clamp(position.y, 0, viewRect.size.y)



func damage(amount: int):
	if life >0:
		life -= amount
		print("Player Life = %s" % life)
	
	if life <= 0:
		emit_signal("isDead")
		yield(get_tree(), "idle_frame") #sem isso, a destruição à seguir impede o sinal de chegar
		queue_free()
