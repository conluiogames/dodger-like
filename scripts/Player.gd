extends Area2D

class_name Player

signal isDead

onready var gameplay := $".."
var plBullet := preload("res://prefabs/Bullet.tscn")
var vel := Vector2(0, 0)
var is_taking_damage: bool = false
var blink_timer = null

onready var player_sprite = $Sprite
onready var firingPositions := $FiringPositions
onready var fireDelayTimer := $Timer

export var speed: float = 100
export var acceleration: float = 400
export var friction: float = 200
export var fireDelay: float = 0.3
export var life: int = 3

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
	
	if life >0 and is_taking_damage == false:
		life -= amount
		print("Player Life = %s" % life)
		invincibility_frame()
	
	if life <= 0:
		emit_signal("isDead")
		yield(get_tree(), "idle_frame") #sem isso, a destruição à seguir impede o sinal de chegar
		queue_free()

func invincibility_frame():
	is_taking_damage = true
	blink_effect()
	yield(get_tree().create_timer(1.0), "timeout")
	is_taking_damage = false
	blink_effect()

func blink_effect():
# versão simples mas funciona:	
	if is_taking_damage == true:
		player_sprite.modulate = Color(1, 0, 0)
	else:
		player_sprite.modulate = Color(1, 1, 1)


#	var blink_duration = 0.1  # Duração de cada piscada em segundos
#
#	if blink_timer:
#		# Se o Timer já existe, reinicie-o e não crie um novo
#		blink_timer.stop()
#		blink_timer.queue_free()
#
#	blink_timer = Timer.new()
#	add_child(blink_timer)
#	blink_timer.wait_time = blink_duration
#	blink_timer.autostart = false
#
#	# Conecta o sinal timeout do Timer ao método _on_blink_timer_timeout
#	blink_timer.connect("timeout", self, "_on_blink_timer_timeout")
#
#	# Inicia o Timer
#	blink_timer.start()
#
#
#func _on_blink_timer_timeout():
#
#	var original_color = Color(1, 1, 1)  # Cor original do Sprite
#	var blink_color = Color(1, 0, 0)  # Cor vermelha para o efeito de piscar
#
#	if is_taking_damage:
#		if player_sprite.modulate == original_color:
#			player_sprite.modulate = blink_color
#		else:
#			player_sprite.modulate = original_color
#			# Reinicia o Timer
#			blink_timer.start()
#	else:
#		# Para o Timer e define a cor original
#		player_sprite.modulate = original_color
#		blink_timer.stop()
#		blink_timer.queue_free()  # Remove o Timer após o uso
