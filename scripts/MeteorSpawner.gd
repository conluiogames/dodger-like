extends Node2D

const MIN_SPAWN_TIME = 1.5

var gameplay
var nextSpawnTime := 3.0
var preloadedMeteor := [
	preload("res://scenes/SmallMeteor.tscn"),
	preload("res://scenes/MidMeteor.tscn"),
	preload("res://scenes/BigMeteor.tscn")
]

onready var spawnTimer := $SpawnTimer

func _ready():
	gameplay = get_node("/root/Gameplay")
	randomize()
	spawnTimer.start(nextSpawnTime)
	
func _on_SpawnTimer_timeout():
	# Spawn an enemy
	var viewRect := get_viewport_rect()
	var xPos := rand_range(viewRect.position.x, viewRect.end.x)
	
	#print(randf())
	
	if randf() > 0.1:

		#A mensagem "Can't add child, already has parent" 
		# em Godot ocorre porque você está tentando adicionar 
		# o mesmo nó a dois pais diferentes. No seu código, 
		# você adiciona o meteor duas vezes: primeiro ao nó "Bodies" 
		# e depois à current_scene. Isso causa o erro, pois um nó só pode ter um pai.

		var meteorPreload = preloadedMeteor[randi() % preloadedMeteor.size()]
		var meteor: Meteor = meteorPreload.instance()
		var bodies_node = get_tree().current_scene.get_node("Bodies")
		bodies_node.add_child(meteor)  # Adiciona meteor ao nó "Bodies"
		meteor.position = Vector2(xPos, position.y)
		meteor.connect("add_score", gameplay, "change_score")

	
	# Restart the timer
	nextSpawnTime -= 0.1
	if nextSpawnTime < MIN_SPAWN_TIME:
		nextSpawnTime = MIN_SPAWN_TIME
	spawnTimer.start(nextSpawnTime)
	
func distroyAllBodies():
	#destroi todos os meteoros
	pass
