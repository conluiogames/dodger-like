extends Node2D

const MIN_SPAWN_TIME = 1.5

var preloadedMeteor := [
	preload("res://assets/scenes/SmallMeteor.tscn"),
	preload("res://assets/scenes/MidMeteor.tscn"),
	preload("res://assets/scenes/BigMeteor.tscn")
]

onready var spawnTimer := $SpawnTimer

var nextSpawnTime := 2.0

func _ready():
	randomize()
	spawnTimer.start(nextSpawnTime)
	
func _on_SpawnTimer_timeout():
	# Spawn an enemy
	var viewRect := get_viewport_rect()
	var xPos := rand_range(viewRect.position.x, viewRect.end.x)
	
	print(randf())
	
	if randf() > 0.1:
		var meteorPreload = preloadedMeteor[randi() % preloadedMeteor.size()]
		var meteor: Meteor = meteorPreload.instance()
		meteor.position = Vector2(xPos, position.y)
		get_tree().current_scene.add_child(meteor)
	
	# Restart the timer
	nextSpawnTime -= 0.1
	if nextSpawnTime < MIN_SPAWN_TIME:
		nextSpawnTime = MIN_SPAWN_TIME
	spawnTimer.start(nextSpawnTime)
