extends Area2D

class_name Enemy

export var minSpeed: float = 10
export var maxSpeed: float = 20

const scn_explosion = preload("res://scenes/Explosion.tscn")

export var life: int = 0

var speed: float = 0
var scorePoints : int
var rotationRate: float = 0
var playerInArea: Player = null

export var velocity = Vector2()

signal add_score(value)

func _ready():
	speed = rand_range(minSpeed, maxSpeed)

func _process(delta):
	translate(velocity * delta)
	if position.y-16 >= Utils.view_size.y:
		queue_free()
	
	if playerInArea != null:
		playerInArea.damage(1)
	
func _physics_process(delta):	
	position.y += speed * delta

func damage(amount: int):
	life -= amount
	if life <= 0:
		emit_signal("add_score", scorePoints)	#Tem que transferir scorePoints...
		create_explosion()
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Enemy_area_entered(area):
	if area is Player:
		playerInArea = area

func _on_Enemy_area_exited(area):
	if area is Player:
		playerInArea = null

func create_explosion():
	var explosion = scn_explosion.instance()
	explosion.position = self.position
	Utils.main_node.add_child(explosion)
	pass
