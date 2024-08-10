extends Node2D

enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }
var current_state = GameState.TITLE

var player_spawner = load("res://scenes/Player.tscn")

var meteor_spawner = load("res://scenes/MeteorSpawner.tscn")
var enemy_spawner = load("res://scenes/EnemySpawner.tscn")
var powerup_spawner = load("res://scenes/PowerupSpawner.tscn")

var titleObj
var gui_node
var variables

signal update_ui_screen
signal initiate_spawn
signal update_score_ui

var score : int = 00000
var record : int = 00000

# Referência ao player instanciado
var player_ref = null

func _ready():
	set_state(GameState.TITLE)
	gui_node = $GUI
	connect("update_ui_screen", self, "update_score_UI")

func set_state(new_state):
	current_state = new_state
	emit_signal("update_ui_screen")
	pass

#===================== CONTROLADORES =============================
func _input(event):
	if event is InputEventKey and event.pressed and (event.scancode == KEY_ENTER or event.scancode == KEY_ESCAPE):
		if current_state == GameState.TITLE:
			start_game()
		elif current_state == GameState.INGAME:
			pause_game()
		elif current_state == GameState.PAUSE:
			resume_game()
	pass

#Adicioanr navegação entre botões pelas setas e ws

#===================== MÁQUINA DE ESTADOS  =============================
#===================== START GAME
func start_game():
	if get_tree().paused:
		get_tree().paused = false
	
	reset_score()
	delete_old_player()
	clean_bodies_node()
	create_new_player()
	create_new_spawners()
	set_state(GameState.INGAME)
	#print("start_game")


#===================== PAUSE GAME
func pause_game():
	set_state(GameState.PAUSE)
	get_tree().paused = true
	#print("pause_game")

#===================== RESUME GAME
func resume_game():
	if get_tree().paused:
		get_tree().paused = false
	yield(get_tree(), "idle_frame")
	set_state(GameState.INGAME)
	#print("unpause_game")

#===================== END GAME
func end_game():
	_compareScores()
	emit_signal("update_ui_screen")
	set_state(GameState.GAMEOVER)
	emit_signal("update_score_ui", score)
	#print("End game iniciado.")

#===================== TITLE GAME
func title_game():
	set_state(GameState.TITLE)
	#print("title_game")

#===================== QUIT GAME
func quit_game():
	get_tree().quit()


#===================== BOTÕES DOS MENUS  =============================
# BOTÕES
func _on_bt_start_pressed():
	start_game()
	
func _on_bt_resume_pressed():
	resume_game()

func _on_bt_restart_pressed():
	start_game()

func _on_bt_quit_pressed():
	quit_game()

func _on_Player_isDead():
	#print("sinal de morte do player recebido")
	player_ref = null  # Redefine player_ref como null
	end_game()


#===================== INSTANCIAÇÃO DOS ATORES  =============================

func delete_old_player():
	for child in get_children():
		if child.name.to_lower().find("player") != -1:
			child.queue_free()

func clean_bodies_node():
	# Deleta todos os corpos do nó "Bodies"
	var bodies_node = get_node("Bodies")
	for child in bodies_node.get_children():
		child.queue_free()

func create_new_player():
	#verifique se player já foi deletado para impedir conflitos (não adiantou)
#	for child in get_children():
#		if child.name.to_lower() == "player":
#			child.queue_free()
#			break
			
	var new_player = player_spawner.instance()
	new_player.name = "player" #para impedir diferenciação no nome
	new_player.add_to_group("player")
	new_player.connect("isDead", self, "_on_Player_isDead")
	new_player.position = Vector2(100, 228)
	self.add_child(new_player)
	self.move_child(new_player, 3)
	player_ref = new_player # Atualiza a referência ao player
	
func create_new_spawners():
	instantiate_spawner(meteor_spawner, "meteor_spawner", Vector2(105, -17))
	instantiate_spawner(enemy_spawner, "enemy_spawner", Vector2(105, -17))
	instantiate_spawner(powerup_spawner, "powerup_spawner", Vector2(105, -17))
	
func instantiate_spawner(spawner, name, position):
	# Apaga instâncias antigas
	for child in get_children():
		if child.name.to_lower().find(name) != -1:
			child.queue_free()

	var new_spawner = spawner.instance()
	new_spawner.name = name
	new_spawner.add_to_group(name)
	new_spawner.position = position
	self.add_child(new_spawner)
	self.move_child(new_spawner, 3)
	

#===================== GERENCIAMENTO DE PONTUAÇÃO  =============================
func _compareScores():
	$GUI/gameover/currentScore.text = str("Placar: " + str(score))
	if score > record:	
		record = score
		$GUI/gameover/currentScore.update()
		$GUI/gameover/record.text = str("Novo Record!")
		$GUI/gameover/record.update()
		emit_signal("update_score_ui", score) #precisa disso?
	else:
		$GUI/gameover/record.text = str("Record: " + str(record))

func change_score(value : int):
	score += value
	#print("Pontuação recebida. Valor: " + str(score))
	emit_signal("update_ui_screen")
	emit_signal("update_score_ui", score)
	
func reset_score():
	score = 00000
	emit_signal("update_ui_screen")
	emit_signal("update_score_ui", score)
