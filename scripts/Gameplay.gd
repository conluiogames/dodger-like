extends Node2D

enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }
var current_state = GameState.TITLE
var titleObj
var gui_node
var variables
signal atualiza_gui

var score : int = 00000
var scoreRecord : int = 00000

func _ready():
	set_state(GameState.TITLE)
	
	print("Máquina atual: " + str(current_state))
	var gui_node = $GUI
	if gui_node != null:
		print("O nó se chama " + gui_node.name)
		print("O seu caminho é " + gui_node.get_path())
		print("Quantidade de filhos: " + str(gui_node.get_child_count()))
		if gui_node.get_script() != null:
			print("Há scripts anexados neste nó")
			print("Nome dos scripts: " + str(gui_node.get_script().resource_path))
	pass 

func _input(event):
	if event is InputEventKey and event.pressed and event.scancode == KEY_K:
		emit_signal("atualiza_gui")


func set_state(new_state):
	current_state = new_state 
	#executa o método relativo a cada estado
#	match current_state:
#		GameState.TITLE:
#			enter_title_state()
#		GameState.INGAME:
#			enter_ingame_state()
#		GameState.PAUSE:
#			enter_pause_state()
#		GameState.GAMEOVER:
#			enter_gameover_state()
	pass


func _compareScores():
	if score > scoreRecord:	
		scoreRecord = score
	pass 

func restart_game():
	pass
	
func quit_game():
	get_tree().quit()
	pass


func _on_bt_start_pressed():
	set_state("INGAME")
	pass 
	
func _on_bt_resume_pressed():
	restart_game()
	pass

func _on_bt_restart_pressed():
	restart_game()
	pass

func _on_bt_quit_pressed():
	quit_game()
	pass


func _on_Player_isDead():
	print("Jogador morreu")
	current_state = GameState.GAMEOVER
	pass
