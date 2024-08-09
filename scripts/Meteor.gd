extends Area2D

class_name Meteor

export var minSpeed: float = 10
export var maxSpeed: float = 20
export var minRotationRate: float = -20
export var maxRotationRate: float = 20

export var life: int = 20

const scn_explosion = preload("res://scenes/Explosion.tscn")

var speed: float = 0
var scorePoints : int
var rotationRate: float = 0
var playerInArea: Player = null

signal add_score(value)

func _ready():
	speed = rand_range(minSpeed, maxSpeed)
	rotationRate = rand_range(minRotationRate, maxRotationRate)
	
func _process(delta):
	if playerInArea != null:
		playerInArea.damage(1)
	
func _physics_process(delta):
	rotation_degrees += rotationRate * delta
	
	position.y += speed * delta

func damage(amount: int):
	life -= amount
	if life <= 0:
		emit_signal("add_score", scorePoints)	#Tem que transferir scorePoints...
		create_explosion()
		queue_free()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()

func _on_Meteor_area_entered(area):
	if area is Player:
		playerInArea = area

func _on_Meteor_area_exited(area):
	if area is Player:
		playerInArea = null

func create_explosion():
	var explosion = scn_explosion.instance()
	explosion.position = self.position
	Utils.main_node.add_child(explosion)
	pass
