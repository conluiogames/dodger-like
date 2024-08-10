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


#===================== MÁQUINA DE ESTADOS  =============================
#===================== START GAME
func start_game():
	if get_tree().paused:
		get_tree().paused = false
	
	#print("start_game")
	reset_score()
	set_state(GameState.INGAME)
	# Apaga instâncias antigas
	for child in get_children():
		if child.name.to_lower().find("player") != -1:
			child.queue_free()

	var new_player = player_spawner.instance()  # Armazena a referência ao player
	new_player.name = "Player"
	new_player.add_to_group("player")
	new_player.connect("isDead", self, "_on_Player_isDead")
	new_player.position = Vector2(100, 228)
	self.add_child(new_player)

	# Atualiza a referência ao player
	player_ref = new_player

	# Instancia os outros spawners
	instantiate_spawner(meteor_spawner, "meteor_spawner", Vector2(105, -17))
	instantiate_spawner(enemy_spawner, "enemy_spawner", Vector2(105, -17))
	instantiate_spawner(powerup_spawner, "powerup_spawner", Vector2(105, -17))

	# Deleta todos os corpos do nó "Bodies"
	var bodies_node = get_node("Bodies")
	for child in bodies_node.get_children():
		child.queue_free()

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

#===================== PAUSE GAME
func pause_game():
	#print("pause_game")
	set_state(GameState.PAUSE)
	get_tree().paused = true

#===================== RESUME GAME
func resume_game():
	get_tree().paused = false
	#print("unpause_game")
	set_state(GameState.INGAME)

#===================== END GAME
func end_game():
	#print("End game iniciado.")
	_compareScores()
	emit_signal("update_ui_screen")
	set_state(GameState.GAMEOVER)
	emit_signal("update_score_ui", score)
	
	#print("Pontuação final no GameOver: %s" % score)

#===================== TITLE GAME
func title_game():
	#print("title_game")
	set_state(GameState.TITLE)

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

#===================== GERENCIAMENTO DE PONTUAÇÃO  =============================
func _compareScores():
	if score > record:	
		record = score
		$GUI/gameover/currentScore.text = str("Placar atual: " + str(score))
		$GUI/gameover/currentScore.update()
		#$GUI/gameover/record.text = str("Record: " + str(record))
		$GUI/gameover/record.text = str("Novo Record!")
		$GUI/gameover/record.update()
		emit_signal("update_score_ui", score)

func change_score(value):
	score += value
	#print("Pontuação recebida. Valor: " + str(score))
	emit_signal("update_ui_screen")
	emit_signal("update_score_ui", score)
	
func reset_score():
	score = 00000
	emit_signal("update_ui_screen")
	emit_signal("update_score_ui", score)
