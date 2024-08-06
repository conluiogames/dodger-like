extends Node2D

const MIN_SPAWN_TIME = 1.5

var gameplay
var nextSpawnTime := 2.0
var preloadedMeteor := [
	preload("res://prefabs/MeteorSmall.tscn"),
	preload("res://prefabs/MeteorMid.tscn"),
	preload("res://prefabs/MeteorBig.tscn")
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
		var meteorPreload = preloadedMeteor[randi() % preloadedMeteor.size()]
		var meteor: Meteor = meteorPreload.instance()
		var bodies_node = get_tree().current_scene.get_node("Bodies")
		bodies_node.add_child(meteor)
		meteor.position = Vector2(xPos, position.y)
		meteor.connect("add_score", gameplay, "change_score") #teste de conexão entre sinal e receptor
		get_tree().current_scene.add_child(meteor)
	
	# Restart the timer
	nextSpawnTime -= 0.1
	if nextSpawnTime < MIN_SPAWN_TIME:
		nextSpawnTime = MIN_SPAWN_TIME
	spawnTimer.start(nextSpawnTime)
	
func distroyAllBodies():
	#destroi todos os meteoros
	pass
