extends Node2D

var titleObj
enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }
var state = GameState.TITLE

var score : int = 00000
var scoreRecord : int = 00000

func _ready():
	set_state(GameState.TITLE)
	print("Máquina atual: " + str(state))
	pass 

func set_state(new_state):
	print("Estado tentará mudar para " + str(new_state))
	match new_state:
		GameState.TITLE:
			enter_title_state()
		GameState.INGAME:
			enter_ingame_state()
		GameState.PAUSE:
			enter_pause_state()
		GameState.GAMEOVER:
			enter_gameover_state()
	print("Máquina atual: " + str(state))
	pass


func enter_title_state():
	print("Entered Title State")
	$GUI.visible = true
	$GUI/title.visible = true
	$GUI/ingame.visible = false
	$GUI/pause.visible = false
	$GUI/gameover.visible = false
	$GUI/commonButtons.visible = false
	pass

func enter_ingame_state():
	print("Entered In-Game State")
	$GUI/title.visible = false
	$GUI/ingame.visible = true
	$GUI/pause.visible = false
	$GUI/gameover.visible = false
	$GUI/commonButtons.visible = false
	pass 

func enter_pause_state():
	print("Entered Pause State")
	$GUI/title.visible = false 
	$GUI/ingame.visible = true
	$GUI/pause.visible = true
	$GUI/gameover.visible = false
	$GUI/commonButtons.visible = true
	pass 

func enter_gameover_state():
	print("Entered Game Over State")
	$GUI/title.visible = false
	$GUI/ingame.visible = false
	$GUI/pause.visible = false
	$GUI/gameover.visible = true
	$GUI/commonButtons.visible = true
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






