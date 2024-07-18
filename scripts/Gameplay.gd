extends Node2D

enum GameState { TITLE, INGAME, PAUSE, GAMEOVER }
var state = GameState.TITLE

var score : int = 00000
var scoreRecord : int = 00000

func _ready():
	set_state(GameState.TITLE)
	pass 

func set_state(new_state):
	state = new_state
	match state:
		GameState.TITLE:
			enter_title_state()
		GameState.INGAME:
			enter_ingame_state()
		GameState.PAUSE:
			enter_pause_state()
		GameState.GAMEOVER:
			enter_gameover_state()

func _compareScores():
	if score > scoreRecord:	
		scoreRecord = score
	pass 

func enter_title_state():
	print("Entered Title State")
	$GUI/title.visible(true)
	$GUI/ingame.hide()
	$GUI/pause.hide()
	$GUI/gameover.hide()
	pass 

func enter_ingame_state():
	print("Entered In-Game State")
	$Gameplay/GUI/title.hide() 
	$Gameplay/GUI/ingame.visible()
	$Gameplay/GUI/pause.hide() 
	$Gameplay/GUI/gameover.hide() 
	pass 

func enter_pause_state():
	print("Entered Pause State")
	$Gameplay/GUI/title.hide() 
	$Gameplay/GUI/ingame.visible()
	$Gameplay/GUI/pause.visible()
	$Gameplay/GUI/gameover.hide() 
	pass 

func enter_gameover_state():
	print("Entered Game Over State")
	$Gameplay/GUI/title.hide() 
	$Gameplay/GUI/ingame.hide() 
	$Gameplay/GUI/pause.hide() 
	$Gameplay/GUI/gameover.visible()
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
