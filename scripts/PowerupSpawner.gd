extends Node2D

const MIN_SPAWN_TIME = 1.5

var gameplay
var nextSpawnTime := 6.0
var preloadedPwrUP := [
	preload("res://scenes/PowerupLaser.tscn"),
	preload("res://scenes/PowerupArmor.tscn")
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

		var puPreload = preloadedPwrUP[randi() % preloadedPwrUP.size()]
		var powerUp: PowerUP = puPreload.instance()
		var bodies_node = get_tree().current_scene.get_node("Bodies")
		bodies_node.add_child(powerUp)  # Adiciona meteor ao nó "Bodies"
		powerUp.position = Vector2(xPos, position.y)
		#powerUp.connect("add_score", gameplay, "change_score")  # Teste de conexão entre sinal e receptor

	
	# Restart the timer
	nextSpawnTime -= 0.1
	if nextSpawnTime < MIN_SPAWN_TIME:
		nextSpawnTime = MIN_SPAWN_TIME
	spawnTimer.start(nextSpawnTime)
	
func distroyAllBodies():
	#destroi todos os meteoros
	pass
