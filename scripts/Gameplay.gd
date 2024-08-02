extends Node2D

enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }

var current_state = GameState.TITLE
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
	pass 

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
	print("start_game")
	reset_score()
	set_state(GameState.INGAME)
	emit_signal("initiate_spawn")
	# resetar o spaw dos corpos
	# recriar o player na posição inicial
	# se estiver em pausa, retirar
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
	
func title_game():
	print("title_game")
	set_state(GameState.TITLE)
	pass

func quit_game():
	get_tree().quit()
	pass


# BOTÕES
func _on_bt_start_pressed():
	start_game()
	pass 
	
func _on_bt_resume_pressed():
	resume_game()
	pass

func _on_bt_restart_pressed():
	start_game()
	pass

func _on_bt_quit_pressed():
	quit_game()
	pass


func _on_Player_isDead():
	print("Jogador morreu")
	set_state(GameState.GAMEOVER)
	emit_signal("atualiza_gui")
	pass

#SCORE
func _compareScores(): 
	if score > scoreRecord:	
		scoreRecord = score
		update_score_UI()
	pass 
	
func change_score():
	var value = 10 #remover após resolver questão do var scorePoints em Meteor.gd
	score = score + value
	print("change score ativado. Valor: " + str(score))
	#emit_signal("atualiza_gui")
	update_score_UI()
	pass
	
func reset_score():
	score = 00000
	#emit_signal("atualiza_gui")
	update_score_UI()
	pass
	
func update_score_UI():
	var value : String  = str(score)
	$GUI/ingame/score.text = value
	pass
