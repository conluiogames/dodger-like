extends Node2D

enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }
var current_state = GameState.TITLE

var player_prefab = load("res://prefabs/Player.tscn")
#var existing_player =  get_tree().get_nodes_in_group("Player")

var spawner_prefab = load("res://prefabs/Spawner.tscn")
#var existing_spawner = get_tree().get_nodes_in_group("Spawner")

var titleObj
var gui_node
var variables

signal atualiza_gui
signal initiate_spawn

var score : int = 00000
var scoreRecord : int = 00000

func _ready():
	set_state(GameState.TITLE)
	var gui_node = $GUI
	#print("Máquina atual: " + str(current_state))
	#if gui_node != null:
#		print("O nó se chama " + gui_node.name)
#		print("O seu caminho é " + gui_node.get_path())
#		print("Quantidade de filhos: " + str(gui_node.get_child_count()))
#		if gui_node.get_script() != null:
#			print("Há scripts anexados neste nó")
#			print("Nome dos scripts: " + str(gui_node.get_script().resource_path))

func set_state(new_state):
	current_state = new_state
	emit_signal("atualiza_gui")
	pass

# COMANDOS
func _input(event):
	if event is InputEventKey and event.pressed and (event.scancode == KEY_ENTER or event.scancode == KEY_ESCAPE):
		if current_state == GameState.TITLE:
			start_game()
		elif current_state == GameState.INGAME:
			pause_game()
		elif current_state == GameState.PAUSE:
			resume_game()
	pass
	
# ESTADOS
func start_game():
	
	if get_tree().paused:
		get_tree().paused = false
	
	print("start_game")
	reset_score()
	set_state(GameState.INGAME)
	
#PLAYER

	#DELETA INSTANCIA VELHA
	var player_count = 0
	for child in get_children():
		if child.name.to_lower().find("player") != -1:
			player_count += 1
			#child.queue_free()

	#INSTANCIA NOVA
	var player_instance = player_prefab.instance()
	player_instance.name = "Player"
	player_instance.add_to_group("player")
	player_instance.position = Vector2(100, 228)
	self.add_child(player_instance)

#SPAWNER

	#DELETA INSTANCIA VELHA
	var spawner_count = 0
	for child in get_children():
		if child.name.to_lower().find("spawner") != -1:
			spawner_count += 1
			child.queue_free()
			
		
	#INSTANCIA NOVA
	var spawner_instance = spawner_prefab.instance()
	spawner_instance.name = "Spawner"
	spawner_instance.add_to_group("spawner")
	spawner_instance.position = Vector2(105, -17)
	self.add_child(spawner_instance)
	
	#recomeçar música (instanciando?)
	# se estiver em pausa, retirar
	
	#DELETAR TODOS OS CORPOS
	var bodies_node = get_node("Bodies")
	for child in bodies_node.get_children():
		child.queue_free()
	
	pass

func pause_game():
	print("pause_game")
	set_state(GameState.PAUSE)
	get_tree().paused = true
	pass

func resume_game():
	get_tree().paused = false
	print("unpause_game")
	set_state(GameState.INGAME)
	pass
	
func end_game():
	print("end_game")
	set_state(GameState.GAMEOVER)
	emit_signal("atualiza_gui")
	pass
		
func title_game():
	print("title_game")
	set_state(GameState.TITLE)
	#redundante, não volta pra esses estado...
	pass

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
	end_game()

#SCORE
func _compareScores(): 
	if score > scoreRecord:	
		scoreRecord = score
		update_score_UI()
	
func change_score(value):
	#value = 10 #remover após resolver questão do var scorePoints em Meteor.gd
	score = score + value
	print("Pontuação recebida. Valor: " + str(score))
	emit_signal("atualiza_gui")
	update_score_UI()
	
func reset_score():
	score = 00000
	emit_signal("atualiza_gui")
	update_score_UI()
	
func update_score_UI():
	var value : String  = str(score)
	$GUI/ingame/score.text = value
