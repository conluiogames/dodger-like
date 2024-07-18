extends Node2D

enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }
var state = GameState.TITLE

var score : int = 00000
var scoreRecord : int = 00000

func _ready():
	pass 


func _compareScores():
	if score > scoreRecord:	
		scoreRecord = score
	pass 

func enter_title_state():
	print("Entered Title State")
	pass 

func enter_ingame_state():
	print("Entered In-Game State")
	pass 

func enter_pause_state():
	print("Entered Pause State")
	pass 

func enter_gameover_state():
	print("Entered Game Over State")
	pass 

func _process(delta):
	match state:
		GameState.TITLE:
			update_title_state(delta)
		GameState.INGAME:
			update_ingame_state(delta)
		GameState.PAUSE:
			update_pause_state(delta)
		GameState.GAMEOVER:
			update_gameover_state(delta)
	pass


func update_title_state(delta):
	# Handle title screen updates
	pass

func update_ingame_state(delta):
	# Handle in-game updates
	pass

func update_pause_state(delta):
	# Handle pause menu updates
	pass

func update_gameover_state(delta):
	# Handle game over screen updates
	pass

func _input(event):
	if event.is_action_pressed("ui_accept"):
		match state:
			GameState.TITLE:
				set_state(GameState.INGAME)
			GameState.INGAME:
				set_state(GameState.PAUSE)
			GameState.PAUSE:
				set_state(GameState.INGAME)
			GameState.GAMEOVER:
				set_state(GameState.TITLE)

