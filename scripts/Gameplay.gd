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

signal atualiza_gui
signal initiate_spawn

var score : int = 00000
var record : int = 00000

# Referência ao player instanciado
var player_ref = null

func _ready():
	set_state(GameState.TITLE)
	gui_node = $GUI
	connect("atualiza_gui", self, "update_score_UI")

func set_state(new_state):
	current_state = new_state
	emit_signal("atualiza_gui")
	pass

func _input(event):
	if event is InputEventKey and event.pressed and (event.scancode == KEY_ENTER or event.scancode == KEY_ESCAPE):
		if current_state == GameState.TITLE:
			start_game()
		elif current_state == GameState.INGAME:
			pause_game()
		elif current_state == GameState.PAUSE:
			resume_game()
	pass

func start_game():
	if get_tree().paused:
		get_tree().paused = false
	
	print("start_game")
	reset_score()
	set_state(GameState.INGAME)

	#===================== PLAYER =============================

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

	#===================== PLAYER =============================

	# Instancia os outros spawners
	instantiate_spawner(meteor_spawner, "meteor_spawner", Vector2(105, -17))
	instantiate_spawner(enemy_spawner, "enemy_spawner", Vector2(105, -17))
	instantiate_spawner(powerup_spawner, "powerup_spawner", Vector2(105, -17))

	# Deleta todos os corpos no nó "Bodies"
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

func pause_game():
	print("pause_game")
	set_state(GameState.PAUSE)
	get_tree().paused = true

func resume_game():
	get_tree().paused = false
	print("unpause_game")
	set_state(GameState.INGAME)

func end_game():
	print("End game iniciado.")
	_compareScores()
	emit_signal("atualiza_gui")
	set_state(GameState.GAMEOVER)
	update_score_UI()
	print("Pontuação final no GameOver: %s" % score)

func title_game():
	print("title_game")
	set_state(GameState.TITLE)

func quit_game():
	get_tree().quit()

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
	print("sinal de morte do player recebido")
	player_ref = null  # Redefine player_ref como null
	end_game()

# SCORE
func _compareScores():
	if score > record:	
		record = score
		$GUI/gameover/currentScore.text = str("Placar atual: " + str(score))
		$GUI/gameover/currentScore.update()
		$GUI/gameover/record.text = str("Record: " + str(record))
		$GUI/gameover/record.update()
		update_score_UI()

func change_score(value):
	score += value
	print("Pontuação recebida. Valor: " + str(score))
	emit_signal("atualiza_gui")
	update_score_UI()
	
func reset_score():
	score = 00000
	emit_signal("atualiza_gui")
	update_score_UI()
	
func update_score_UI():
	var value : String = str(score)
	if player_ref != null:
		var playerLife : String = str(player_ref.life)
		$GUI/ingame/lives.text = playerLife
		$GUI/ingame/lives.update()  # Atualiza a vida do player
	else:
		print("player_ref é null, não é possível atualizar a vida do jogador.")
	$GUI/ingame/score.text = value
	$GUI/ingame/score.update()  # Força a atualização da interface
	print("UI atualizada com pontuação: %s" % value)

